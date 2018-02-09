<html>
    <head>
        <title>BudgetMaster</title>
        <meta charset="UTF-8"/>
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.100.2/css/materialize.css">
        <link type="text/css" rel="stylesheet" href="/css/main.css"/>
        <link type="text/css" rel="stylesheet" href="/css/style.css"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    </head>
    <body class="budgetmaster-blue-light">
        <ul id="slide-out" class="side-nav fixed">
            <li><a href="" class="waves-effect" id="nav-logo-container"><img id="nav-logo" src="/images/Logo_with_text.png"></a></li>
            <li><div class="divider"></div></li>
            <li class="active"><a href="#!" class="waves-effect"><i class="material-icons">home</i>Startseite</a></li>
            <li><a href="#!" class="waves-effect"><i class="material-icons">list</i>Buchungen</a></li>
            <li>
                <ul class="collapsible collapsible-accordion no-padding">
                    <li>
                        <a class="collapsible-header nav-padding"><i class="material-icons">show_chart</i>Diagramme</a>
                        <div class="collapsible-body nav-padding">
                            <ul>
                                <li><a href="#!" class="waves-effect">Eingaben/Ausgaben nach Kategorien</a></li>
                                <li><a href="#!" class="waves-effect">Eingaben/Ausgaben pro Monat</a></li>
                                <li><a href="#!" class="waves-effect">Eingaben/Ausgaben nach Tags</a></li>
                                <li><a href="#!" class="waves-effect">Verbrauch nach Kategorien</a></li>
                                <li><a href="#!" class="waves-effect">Histogramm</a></li>
                            </ul>
                        </div>
                    </li>
                </ul>
            </li>
            <li><a href="#!" class="waves-effect"><i class="material-icons">description</i>Berichte</a></li>
            <li><a href="#!" class="waves-effect"><i class="material-icons">label</i>Kategorien</a></li>
            <li><a href="#!" class="waves-effect"><i class="material-icons">settings</i>Einstellungen</a></li>
            <li><div class="divider"></div></li>
            <li><a href="#!" class="waves-effect"><i class="material-icons">lock</i>Logout</a></li>
        </ul>
        <a href="#" data-activates="slide-out" class="button-collapse show-on-large"><i class="material-icons">menu</i></a>

        <main>
            <div class="card main-card">
                <div class="container">
                    <div class="section center-align">
                        <a href="" class="waves-effect grey-text text-darken-4"><i class="material-icons icon-chevron">chevron_left</i></a>
                        <a href="" class="waves-effect grey-text text-darken-4 date">September 2018</a>
                        <a href="" class="waves-effect grey-text text-darken-4"><i class="material-icons icon-chevron">chevron_right</i></a>
                    </div>
                </div>
                <div class="hide-on-small-only"><br></div>
                <div class="container">
                    <div class="row">
                        <div class="col s12 m4">
                            <div class="icon-block">
                                <h1 class="center text-green"><i class="material-icons icon-budget">file_download</i></h1>
                                <h5 class="center budget">2350,15 €</h5>
                                <h5 class="center grey-text text-darken-1 budget-headline">Einnahmen</h5>
                            </div>
                        </div>
                        <div class="col s12 m4">
                            <div class="icon-block">
                                <h1 class="center text-red"><i class="material-icons icon-budget">file_upload</i></h1>
                                <h5 class="center budget">-576,33 €</h5>
                                <h5 class="center grey-text text-darken-1 budget-headline">Ausgaben</h5>
                            </div>
                        </div>
                        <div class="col s12 m4">
                            <div class="icon-block">
                                <h1 class="center budgetmaster-blue-text"><i class="material-icons icon-budget">account_balance</i></h1>
                                <h5 class="center budget">1773,82 €</h5>
                                <h5 class="center grey-text text-darken-1 budget-headline">Rest</h5>
                            </div>
                        </div>
                    </div>
                    <div class="hide-on-small-only"><br><br></div>
                    <div class="row">
                        <div class="col s12">
                            <div class="budget-bar-container">
                                <div class="budget-bar color-green" style="width: 100%"></div>
                            </div>
                            <div class="budget-bar-container">
                                <div class="budget-bar color-red" style="width: 25%"></div>
                            </div>
                            <div class="budget-bar-container">
                                <div class="budget-bar budgetmaster-blue" style="width: 75%"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!--  Scripts-->
        <script src="https://code.jquery.com/jquery-2.1.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.100.2/js/materialize.min.js"></script>
        <script src="/js/main.js"></script>
    </body>
</html>