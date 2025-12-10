sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"com/ust/po/poheadersitem/test/integration/pages/POHeadersList",
	"com/ust/po/poheadersitem/test/integration/pages/POHeadersObjectPage",
	"com/ust/po/poheadersitem/test/integration/pages/POItemsObjectPage"
], function (JourneyRunner, POHeadersList, POHeadersObjectPage, POItemsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('com/ust/po/poheadersitem') + '/test/flp.html#app-preview',
        pages: {
			onThePOHeadersList: POHeadersList,
			onThePOHeadersObjectPage: POHeadersObjectPage,
			onThePOItemsObjectPage: POItemsObjectPage
        },
        async: true
    });

    return runner;
});

