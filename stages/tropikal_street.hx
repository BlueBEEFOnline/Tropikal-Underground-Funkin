var stage:Stage = null;
function create() {
	stage = loadStage('tropikal_street');
}
function update(elapsed) {
	stage.update(elapsed);
}
function beatHit(curBeat) {
	stage.onBeat();
}