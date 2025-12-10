sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"com/ust/assocn/assocn/test/integration/pages/AuthorsList",
	"com/ust/assocn/assocn/test/integration/pages/AuthorsObjectPage",
	"com/ust/assocn/assocn/test/integration/pages/BooksObjectPage"
], function (JourneyRunner, AuthorsList, AuthorsObjectPage, BooksObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('com/ust/assocn/assocn') + '/test/flp.html#app-preview',
        pages: {
			onTheAuthorsList: AuthorsList,
			onTheAuthorsObjectPage: AuthorsObjectPage,
			onTheBooksObjectPage: BooksObjectPage
        },
        async: true
    });

    return runner;
});

