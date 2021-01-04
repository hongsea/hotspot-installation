var toggle = document.getElementById('container-toggle');
var toggleContainer = document.getElementById('toggle-container');
var textOnline = document.getElementById('textonline');
var textOffline = document.getElementById('textoffline');
var toggleNumber;

toggle.addEventListener('click', function() {
	toggleNumber = !toggleNumber;
	if (toggleNumber) {
		toggleContainer.style.clipPath = 'inset(0 0 0 50%)';
		toggleContainer.style.backgroundColor = 'dodgerblue';
		textOnline.style.display = "block";
		textOffline.style.display = "none";
	} else {
		toggleContainer.style.clipPath = 'inset(0 50% 0 0)';
		toggleContainer.style.backgroundColor = '#D74046';
		textOffline.style.display = "block";
		textOnline.style.display = "none";
	}
	console.log(toggleNumber)
});