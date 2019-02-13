<html>
    <head>
        <#import "../helpers/header.ftl" as header>
        <@header.header "BudgetMaster"/>
        <@header.style "categories"/>
        <@header.style "globalDatepicker"/>
        <#import "/spring.ftl" as s>
    </head>
    <body class="budgetmaster-blue-light">
        <#import "../helpers/navbar.ftl" as navbar>
        <@navbar.navbar "transactions"/>

        <#import "transactionsMacros.ftl" as transactionsMacros>

        <main>
            <div class="card main-card background-color">
                <#import "../helpers/globalDatePicker.ftl" as datePicker>
                <@datePicker.datePicker currentDate springMacroRequestContext.getRequestUri()/>
                <div class="container">
                    <div class="row">
                        <div class="col s4">
                            <div class="icon-block">
                                <h1 class="center text-green budget-headline-icon"><i class="material-icons icon-budget">file_download</i></h1>
                                <h5 class="center budget">${helpers.getCurrencyString(incomeSum)}</h5>
                                <h5 class="center budget-headline">${locale.getString("title.incomes")}</h5>
                            </div>
                        </div>
                        <div class="col s4">
                            <div class="icon-block">
                                <h1 class="center ${redTextColor} budget-headline-icon"><i class="material-icons icon-budget">file_upload</i></h1>
                                <h5 class="center budget">${helpers.getCurrencyString(paymentSum)}</h5>
                                <h5 class="center budget-headline">${locale.getString("title.expenditures")}</h5>
                            </div>
                        </div>
                        <div class="col s4">
                            <div class="icon-block">
                                <h1 class="center budgetmaster-blue-text budget-headline-icon"><i class="fas fa-piggy-bank icon-budget"></i></h1>
                                <h5 class="center budget">${helpers.getCurrencyString(rest)}</h5>
                                <h5 class="center budget-headline">${locale.getString("title.rest")}</h5>
                            </div>
                        </div>
                    </div>

                    <#-- button new -->
                    <div class="row valign-wrapper">
                        <div class="col s12 center-align"><a href="<@s.url '/transactions/newTransaction'/>" class="waves-effect waves-light btn budgetmaster-blue"><i class="material-icons left">add</i>${locale.getString("title.transaction.new")}</a></div>
                    </div>

                    <#-- transactions list -->
                    <br>
                    <div class="row">
                        <div class="col s12">
                            <table class="bordered">
                                <#list transactions as transaction>
                                    <tr>
                                        <td>${helpers.getDateString(transaction.date)}</td>
                                        <@transactionsMacros.transactionRepeating transaction/>
                                        <@transactionsMacros.transactionCategory transaction/>
                                        <@transactionsMacros.transactionNameAndDescription transaction/>
                                        <@transactionsMacros.transactionAmount transaction.getAmount()/>
                                        <@transactionsMacros.transactionButtons transaction/>
                                    </tr>
                                </#list>
                            </table>
                        </div>
                    </div>

                    <#-- show placeholde text if no transactions are present in the current month or REST ist the only transaction -->
                    <@transactionsMacros.placeholder transactions/>
                </div>
            </div>

            <#if currentTransaction??>
                <@transactionsMacros.deleteModal currentTransaction/>
            </#if>
        </main>

        <!--  Scripts-->
        <#import "../helpers/scripts.ftl" as scripts>
        <@scripts.scripts/>
        <script src="<@s.url '/js/transactions.js'/>"></script>
        <script src="<@s.url '/js/globalDatePicker.js'/>"></script>
        <script>document.cookie = "currentDate=${helpers.getDateString(currentDate)}";</script>
    </body>
</html>
