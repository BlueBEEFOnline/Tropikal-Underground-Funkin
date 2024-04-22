var stage:Stage = null;
function create() {
	stage = loadStage('street_bg_week4');
}
function update(elapsed) {
	stage.update(elapsed);
}
function beatHit(curBeat) {
	stage.onBeat();
}