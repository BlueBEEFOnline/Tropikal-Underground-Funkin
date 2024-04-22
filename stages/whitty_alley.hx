var stage:Stage = null;
function create() {
	stage = loadStage('whitty_alley');
}
function update(elapsed) {
	stage.update(elapsed);
}
function beatHit(curBeat) {
	stage.onBeat();
}