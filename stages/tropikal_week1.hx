var stage:Stage = null;
function create() {
	stage = loadStage('tropikal_week1');
}
function update(elapsed) {
	stage.update(elapsed);
}
function beatHit(curBeat) {
	stage.onBeat();
}