sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ObjectPage(
        {
            appId: 'com.ust.po.poheadersitem',
            componentId: 'POItemsObjectPage',
            contextPath: '/POHeaders/items'
        },
        CustomPageDefinitions
    );
});