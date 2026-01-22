<!DOCTYPE html>
<!--
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Simple. by Sara (saratusar.com, @saratusar) for Innovatif - an awesome Slovenia-based digital agency (innovatif.com/en)
Change it, enhance it and most importantly enjoy it!
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-->

<!--[if !IE]><!-->
<html lang="$ContentLocale">
<!--<![endif]-->
<!--[if IE 6 ]><html lang="$ContentLocale" class="ie ie6"><![endif]-->
<!--[if IE 7 ]><html lang="$ContentLocale" class="ie ie7"><![endif]-->
<!--[if IE 8 ]><html lang="$ContentLocale" class="ie ie8"><![endif]-->
<head>
	<% base_tag %>
	<title><% if $MetaTitle %>$MetaTitle<% else %>$Title<% end_if %> &raquo; $SiteConfig.Title</title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	$MetaTags(false)

	<link rel="shortcut icon" href="$resourceURL('themes/simple/images/favicon.ico')" />
	
	<!-- Google Fonts: Questrial -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Questrial&display=swap" rel="stylesheet">
	
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@9/swiper-bundle.min.css"/>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-LN+7fdVzj6u52u30Kp6M/trliBMCMKTyK833zpbD+pXdCLuTusPj6FH4R/5mcr" crossorigin="anonymous">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.css" />
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

	
	<!-- Custom Typography Styles -->
	<style>
		/* Apply Questrial font globally */
		* {
			font-family: 'Questrial', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
		}
		
		body {
			font-family: 'Questrial', sans-serif;
			font-size: 16px;
			line-height: 1.6;
			color: #333;
		}
		
		h1, h2, h3, h4, h5, h6 {
			font-family: 'Questrial', sans-serif;
			font-weight: 400;
			line-height: 1.3;
		}
		
		button, input, select, textarea, .btn {
			font-family: 'Questrial', sans-serif;
		}
		
		/* Optional: Override Bootstrap's default font stack */
		.typography {
			font-family: 'Questrial', sans-serif;
		}
		
		/* Ensure form elements use Questrial */
		.form-control, .form-select, .form-check-label {
			font-family: 'Questrial', sans-serif;
		}
		
		/* Alert messages */
		.alert {
			font-family: 'Questrial', sans-serif;
		}
		
		/* Navigation */
		.navbar, .nav-link {
			font-family: 'Questrial', sans-serif;
		}
	</style>
</head>
<body class="$ClassName.ShortName<% if not $Menu(2) %> no-sidebar<% end_if %>" <% if $i18nScriptDirection %> dir="$i18nScriptDirection"<% end_if %>>

	<% include Header %>


<% if $UserMessage %>
    <div class="alert alert-{$UserMessage.type}" style="margin: 20px; padding: 15px; border-radius: 5px;">
        $UserMessage.text
    </div>
<% end_if %>

<div class="main" role="main">
	<div class="inner typography line">
		$Layout
		<% if $Session.FlashMessage %>
		<div class="container mt-3">
			<div class="alert alert-$Session.FlashMessage.Type alert-dismissible fade show" role="alert">
				$Session.FlashMessage.Message
				<button type="button" class="btn-close" data-bs-dismiss="alert"></button>
			</div>
		</div>
		<% end_if %>
	</div>
</div>

<% include Footer %>

<% require css('https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css') %>
<% require css('https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css') %>

<% require javascript('//code.jquery.com/jquery-3.7.1.min.js') %>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.js"></script>

</body>
</html>