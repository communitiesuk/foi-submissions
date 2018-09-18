var printButtons = document.querySelectorAll('.js-print-button');

for (var i = 0; i < printButtons.length; i++) {
    printButtons[i].addEventListener('click', function(){
        window.print();
    });
}
