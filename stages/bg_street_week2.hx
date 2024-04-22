var stage:Stage = null;
function create() {
	stage = loadStage('bg_street_week2');
}
function update(elapsed) {
	stage.update(elapsed);
}
function beatHit(curBeat) {
	stage.onBeat();
}