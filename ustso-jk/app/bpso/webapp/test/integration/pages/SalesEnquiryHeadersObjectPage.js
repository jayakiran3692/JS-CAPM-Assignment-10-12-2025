sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ObjectPage(
        {
            appId: 'com.ust.ustso.ustsojkmain',
            componentId: 'SalesEnquiryHeadersObjectPage',
            contextPath: '/BusinessPartners/enquiries'
        },
        CustomPageDefinitions
    );
});