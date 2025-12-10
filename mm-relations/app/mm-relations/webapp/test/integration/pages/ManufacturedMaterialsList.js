sap.ui.define(['sap/fe/test/ListReport'], function(ListReport) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ListReport(
        {
            appId: 'com.ust.mmrelations.mmrelations',
            componentId: 'ManufacturedMaterialsList',
            contextPath: '/ManufacturedMaterials'
        },
        CustomPageDefinitions
    );
});