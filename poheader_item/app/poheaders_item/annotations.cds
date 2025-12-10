using PurchaseOrderService as service from '../../srv/service';
annotate service.POHeaders with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'poNumber',
                Value : poNumber,
            },
            {
                $Type : 'UI.DataField',
                Label : 'companyCode',
                Value : companyCode,
            },
            {
                $Type : 'UI.DataField',
                Label : 'purchasingOrg',
                Value : purchasingOrg,
            },
            {
                $Type : 'UI.DataField',
                Label : 'purchasingGroup',
                Value : purchasingGroup,
            },
            {
                $Type : 'UI.DataField',
                Label : 'vendorId',
                Value : vendorId,
            },
            {
                $Type : 'UI.DataField',
                Label : 'vendorName',
                Value : vendorName,
            },
            {
                $Type : 'UI.DataField',
                Label : 'docType',
                Value : docType,
            },
            {
                $Type : 'UI.DataField',
                Label : 'docDate',
                Value : docDate,
            },
            {
                $Type : 'UI.DataField',
                Label : 'postingDate',
                Value : postingDate,
            },
            {
                $Type : 'UI.DataField',
                Label : 'currency',
                Value : currency,
            },
            {
                $Type : 'UI.DataField',
                Label : 'exchangeRate',
                Value : exchangeRate,
            },
            {
                $Type : 'UI.DataField',
                Label : 'paymentTerms',
                Value : paymentTerms,
            },
            {
                $Type : 'UI.DataField',
                Label : 'incoterms',
                Value : incoterms,
            },
            {
                $Type : 'UI.DataField',
                Label : 'reference',
                Value : reference,
            },
            {
                $Type : 'UI.DataField',
                Label : 'status',
                Value : status,
            },
            {
                $Type : 'UI.DataField',
                Label : 'totalAmount',
                Value : totalAmount,
            },
            {
                $Type : 'UI.DataField',
                Label : 'quantityTotal',
                Value : quantityTotal,
            },
            {
                $Type : 'UI.DataField',
                Label : 'plant',
                Value : plant,
            },
            {
                $Type : 'UI.DataField',
                Label : 'createdByApp',
                Value : createdByApp,
            },
            {
                $Type : 'UI.DataField',
                Label : 'headerNote',
                Value : headerNote,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'poNumber',
            Value : poNumber,
        },
        {
            $Type : 'UI.DataField',
            Label : 'companyCode',
            Value : companyCode,
        },
        {
            $Type : 'UI.DataField',
            Label : 'purchasingOrg',
            Value : purchasingOrg,
        },
        {
            $Type : 'UI.DataField',
            Label : 'purchasingGroup',
            Value : purchasingGroup,
        },
        {
            $Type : 'UI.DataField',
            Label : 'vendorId',
            Value : vendorId,
        },
    ],
);

