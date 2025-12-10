sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"project1/test/integration/pages/ProjectsList",
	"project1/test/integration/pages/ProjectsObjectPage",
	"project1/test/integration/pages/MilestonesObjectPage"
], function (JourneyRunner, ProjectsList, ProjectsObjectPage, MilestonesObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('project1') + '/test/flp.html#app-preview',
        pages: {
			onTheProjectsList: ProjectsList,
			onTheProjectsObjectPage: ProjectsObjectPage,
			onTheMilestonesObjectPage: MilestonesObjectPage
        },
        async: true
    });

    return runner;
});

