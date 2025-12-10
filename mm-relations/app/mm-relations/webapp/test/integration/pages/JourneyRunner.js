sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"com/ust/mmrelations/mmrelations/test/integration/pages/ManufacturedMaterialsList",
	"com/ust/mmrelations/mmrelations/test/integration/pages/ManufacturedMaterialsObjectPage",
	"com/ust/mmrelations/mmrelations/test/integration/pages/RawMaterialsObjectPage"
], function (JourneyRunner, ManufacturedMaterialsList, ManufacturedMaterialsObjectPage, RawMaterialsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('com/ust/mmrelations/mmrelations') + '/test/flp.html#app-preview',
        pages: {
			onTheManufacturedMaterialsList: ManufacturedMaterialsList,
			onTheManufacturedMaterialsObjectPage: ManufacturedMaterialsObjectPage,
			onTheRawMaterialsObjectPage: RawMaterialsObjectPage
        },
        async: true
    });

    return runner;
});

