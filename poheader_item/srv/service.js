const cds = require('@sap/cds');

module.exports = cds.service.impl(function () {
  const { POHeaders, POItems } = this.entities;

  const PATTERNS = {
    poNumber: /^[0-9]{10}$/,
    companyCode: /^[0-9A-Z]{4}$/,
    purchasingOrg: /^[0-9A-Z]{4}$/,
    purchasingGroup: /^[0-9A-Z]{3}$/,
    vendorId: /^V[0-9]{9}$/,
    currency: /^[A-Z]{3}$/,

    plant: /^[0-9A-Z]{4}$/,
    material: /^[A-Z0-9_\-]{3,40}$/,
    orderUnit: /^[A-Z]{2,3}$/,
    taxCode: /^[A-Z0-9]{1,2}$/,
    accountAssignCat: /^[A-Z0-9]$/,
    glAccount: /^[0-9]{4,10}$/,
    costCenter: /^[A-Z0-9]{4,10}$/,
    wbselement: /^[A-Z0-9-]{4,24}$/,
    itemCategory: /^[A-Z0-9]$/,
    status: /^[ONRC]$/,
  };

  function fieldError(req, field, message) {
    req.error(400, message, { target: field });
  }

  function validateHeader(req) {
    const data = req.data;

    if (data.poNumber && !PATTERNS.poNumber.test(data.poNumber)) {
      fieldError(req, 'poNumber', 'PO Number must be exactly 10 digits.');
    }

    if (data.vendorId && !PATTERNS.vendorId.test(data.vendorId)) {
      fieldError(req, 'vendorId', 'Vendor ID must start with "V" followed by 9 digits.');
    }

    if (data.companyCode && !PATTERNS.companyCode.test(data.companyCode)) {
      fieldError(req, 'companyCode', 'Company Code must be 4 alphanumeric uppercase characters.');
    }
    if (data.purchasingOrg && !PATTERNS.purchasingOrg.test(data.purchasingOrg)) {
      fieldError(req, 'purchasingOrg', 'Purchasing Org must be 4 alphanumeric uppercase characters.');
    }
    if (data.purchasingGroup && !PATTERNS.purchasingGroup.test(data.purchasingGroup)) {
      fieldError(req, 'purchasingGroup', 'Purchasing Group must be 3 alphanumeric uppercase characters.');
    }

    if (data.currency && !PATTERNS.currency.test(data.currency)) {
      fieldError(req, 'currency', 'Currency must be a 3-letter ISO code (e.g. INR, USD).');
    }

    if (data.status && !PATTERNS.status.test(data.status)) {
      fieldError(req, 'status', 'Status must be one of O, N, R, or C.');
    }

    if (Array.isArray(data.items) && data.items.length > 0 && data.totalAmount != null) {
      const sumItems = data.items.reduce((s, it) => s + (Number(it.netPrice) || 0) * (Number(it.quantity) || 0), 0);
      if (Math.abs(sumItems - Number(data.totalAmount)) > 0.01) {
        fieldError(
          req,
          'totalAmount',
          `Header totalAmount (${data.totalAmount}) does not match summed item value (${sumItems.toFixed(2)}).`
        );
      }
    }
  }

  function validateItem(req) {
    const data = req.data;

    if (data.itemNumber != null && (data.itemNumber < 1 || data.itemNumber > 9999)) {
      fieldError(req, 'itemNumber', 'Item number must be between 1 and 9999.');
    }

    if (data.material && !PATTERNS.material.test(data.material)) {
      fieldError(req, 'material', 'Material must be 3–40 chars, A–Z, 0–9, _, or -.');
    }

    if (data.plant && !PATTERNS.plant.test(data.plant)) {
      fieldError(req, 'plant', 'Plant must be 4 alphanumeric uppercase characters.');
    }

    if (data.storageLocation && !PATTERNS.plant.test(data.storageLocation)) {
      fieldError(req, 'storageLocation', 'Storage location must be 4 alphanumeric uppercase characters.');
    }

    if (data.orderUnit && !PATTERNS.orderUnit.test(data.orderUnit)) {
      fieldError(req, 'orderUnit', 'Order unit must be 2–3 uppercase letters.');
    }

    if (data.taxCode && !PATTERNS.taxCode.test(data.taxCode)) {
      fieldError(req, 'taxCode', 'Tax code must be 1–2 alphanumeric characters.');
    }

    if (data.accountAssignCat && !PATTERNS.accountAssignCat.test(data.accountAssignCat)) {
      fieldError(req, 'accountAssignCat', 'Account assignment category must be a single alphanumeric char.');
    }

    if (data.glAccount && !PATTERNS.glAccount.test(data.glAccount)) {
      fieldError(req, 'glAccount', 'GL Account must be 4–10 digits.');
    }

    if (data.costCenter && !PATTERNS.costCenter.test(data.costCenter)) {
      fieldError(req, 'costCenter', 'Cost center must be 4–10 alphanumeric uppercase characters.');
    }

    if (data.wbselement && !PATTERNS.wbselement.test(data.wbselement)) {
      fieldError(req, 'wbselement', 'WBS Element must be 4–24 chars (A–Z, 0–9, -).');
    }

    if (data.itemCategory && !PATTERNS.itemCategory.test(data.itemCategory)) {
      fieldError(req, 'itemCategory', 'Item category must be a single alphanumeric char.');
    }

    if (data.quantity != null && Number(data.quantity) <= 0) {
      fieldError(req, 'quantity', 'Quantity must be greater than zero.');
    }

    if (data.netPrice != null && Number(data.netPrice) < 0) {
      fieldError(req, 'netPrice', 'Net price must not be negative.');
    }
  }

  this.before(['CREATE', 'UPDATE'], POHeaders, validateHeader);

  this.before(['CREATE', 'UPDATE'], POItems, validateItem);

  this.before(['CREATE', 'UPDATE'], POHeaders, req => {
    const data = req.data;
    if (Array.isArray(data.items)) {
      for (const item of data.items) {

        const fakeReq = {
          data: item,
          error: (...args) => req.error(...args),
        };
        validateItem(fakeReq);
      }
    }
  });
});