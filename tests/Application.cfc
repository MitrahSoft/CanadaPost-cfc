component{
	this.name = 'MitrahSoft CanadaPost ColdFusion API wrapper Test';

	this.mappings['/tests'] = getDirectoryFromPath(getCurrentTemplatePath());
	this.mappings['/testbox'] = getDirectoryFromPath(getCurrentTemplatePath()) & "../../testbox";
}
