sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"com/ust/ustso/ustsojkmain/test/integration/pages/BusinessPartnersList",
	"com/ust/ustso/ustsojkmain/test/integration/pages/BusinessPartnersObjectPage",
	"com/ust/ustso/ustsojkmain/test/integration/pages/SalesEnquiryHeadersObjectPage"
], function (JourneyRunner, BusinessPartnersList, BusinessPartnersObjectPage, SalesEnquiryHeadersObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('com/ust/ustso/ustsojkmain') + '/test/flp.html#app-preview',
        pages: {
			onTheBusinessPartnersList: BusinessPartnersList,
			onTheBusinessPartnersObjectPage: BusinessPartnersObjectPage,
			onTheSalesEnquiryHeadersObjectPage: SalesEnquiryHeadersObjectPage
        },
        async: true
    });

    return runner;
});

