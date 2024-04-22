var stage:Stage = null;
function create() {
	stage = loadStage('alle_streetweek5');
}
function update(elapsed) {
	stage.update(elapsed);
}
function beatHit(curBeat) {
	stage.onBeat();
}