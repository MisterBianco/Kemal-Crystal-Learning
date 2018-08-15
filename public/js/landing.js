const re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;

(function() {
    var burger = document.querySelector('.burger');
    var menu = document.querySelector('#'+burger.dataset.target);
    burger.addEventListener('click', function() {
        burger.classList.toggle('is-active');
        menu.classList.toggle('is-active');
    });
})();

function validateEmail(email) {
    return re.test(String(email).toLowerCase());
}

$(".menu-label").click(function() {
    console.log("click");
    if ( $('.menu-list').css('display') == 'none' ) {

        $('.menu-list').css('display','block');
    } else {
        
        $('.menu-list').css('display','none');
    }
});

$("#email-button").click(function(){

    if (validateEmail($("#email").val())) {
        $.post(
            "/api/email",
            {"email": $("#email").val()},

            function(data, status) {
                alert("You have been added to my subscribers list.");
                $("#email").val("");
            }
        );
    } else {
        alert("Invalid Email");
    }
});
