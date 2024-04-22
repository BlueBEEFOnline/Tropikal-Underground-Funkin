var stage:Stage = null;
function create() {
	stage = loadStage('stage_bg1');
}
function update(elapsed) {
	stage.update(elapsed);
}
function beatHit(curBeat) {
	stage.onBeat();
}