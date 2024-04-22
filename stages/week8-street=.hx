var stage:Stage = null;
function create() {
	stage = loadStage('week8-street=');
}
function update(elapsed) {
	stage.update(elapsed);
}
function beatHit(curBeat) {
	stage.onBeat();
}