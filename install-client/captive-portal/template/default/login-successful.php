<!-- php -->
<!-- /*

 */


// echo "<div class='login-respons'>success</div>";
// echo "<div class='container-fluid'><div class='alert-wrapper  text-center'>";

// echo "<div class='alert alert-primary text-center' role='alert'>
//     $h1Successful";
// if ($reply) { 
//   echo "<hr><p class='mb-0'>$reply</p>";
// }
// echo "</div>";
// echo "<a class='btn btn-success' href=\"http://$uamip:$uamport/logoff\" role='button'>Logout</a>";
// echo "</div></div>";
// header("Location: https://world.koompi.org",true, 301);
// echo "helloaa"
// exit(); -->

<!-- ?> -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Redirect</title>
    <link rel="stylesheet" href="css/style.css">
    <script src="../../js/sweetalert.min.js"></script>
    <script>
        function JSalert(){        
            swal({
                title: "អបអរសារទរ !",
                text: "ការផ្ទៀងផ្ទាត់អត្តសញ្ញាណរបស់អ្នកបានជោគជ័យ",
                type: "success",
                timer: 3000,
                icon: "success",
                button: false
            }).then(function() {
                location.replace("https://world.DOMAIN")
            });
        }
    </script>
</head>
<body onload="JSalert()">
</body>
</html>