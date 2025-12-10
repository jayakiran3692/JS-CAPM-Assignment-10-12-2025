sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ObjectPage(
        {
            appId: 'com.ust.mmrelations.mmrelations',
            componentId: 'RawMaterialsObjectPage',
            contextPath: '/ManufacturedMaterials/rawMaterials'
        },
        CustomPageDefinitions
    );
});