<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

require __DIR__ . "/vendor/autoload.php";

$mail = new PHPMailer(true);

$mail->isSMTP();
$mail->SMTPAuth = true;
$mail->Host = "smtp.gmail.com";  // Replace with your SMTP server
$mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
$mail->Port = 587;
$mail->Username = "sihatselalu716@gmail.com";  // Replace with your email
$mail->Password = "bfzz sgnr hdcj pyhs";  // Replace with your password

$mail->isHtml(true);

// Return the configured PHPMailer instance
return $mail;
?>
