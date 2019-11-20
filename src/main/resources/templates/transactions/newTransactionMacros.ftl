<#import "/spring.ftl" as s>

<#macro isExpenditureSwitch transaction isPayment>
    <#if isPayment>
        <#assign colorButtonIncome = "budgetmaster-grey budgetmaster-text-isPayment">
        <#assign colorButtonExpenditure = "budgetmaster-red">
    <#else>
        <#assign colorButtonIncome = "budgetmaster-green">
        <#assign colorButtonExpenditure = "budgetmaster-grey budgetmaster-text-isPayment">
    </#if>

    <input type="hidden" name="isPayment" id="input-isPayment" value="${isPayment?c}">

    <div class="row">
        <div class="col s12 center-align">
            <div class="row hide-on-small-only">
                <div class="col s6 right-align">
                    <@buttonIncome colorButtonIncome/>
                </div>
                <div class="col s6 left-align">
                    <@buttonExpenditure colorButtonExpenditure/>
                </div>
            </div>

            <div class="hide-on-med-and-up">
                <div class="row center-align">
                    <div class="col s12">
                        <@buttonIncome colorButtonIncome/>
                    </div>
                </div>
                <div class="row center-align">
                    <div class="col s12">
                        <@buttonExpenditure colorButtonExpenditure/>
                    </div>
                </div>
            </div>
        </div>
    </div>
</#macro>

<#macro buttonIncome color>
    <a class="waves-effect waves-light btn ${color} buttonIncome"><i class="material-icons left">file_download</i>${locale.getString("title.income")}</a>
</#macro>

<#macro buttonExpenditure color>
    <a class="waves-effect waves-light btn ${color} buttonExpenditure"><i class="material-icons left">file_upload</i>${locale.getString("title.expenditure")}</a>
</#macro>

<#macro transactionName transaction>
    <div class="row">
        <div class="input-field col s12 m12 l8 offset-l2">
            <input id="transaction-name" type="text" name="name" <@validation.validation "name"/> value="<#if transaction.getName()??>${transaction.getName()}</#if>">
            <label for="transaction-name">${locale.getString("transaction.new.label.name")}</label>
        </div>
    </div>
</#macro>

<#macro transactionAmount transaction>
    <div class="row">
        <div class="input-field col s12 m12 l8 offset-l2">
            <input id="transaction-amount" type="text" <@validation.validation "amount"/> value="<#if transaction.getAmount()??>${currencyService.getAmountString(transaction.getAmount())}</#if>">
            <label for="transaction-amount">${locale.getString("transaction.new.label.amount")}</label>
        </div>
        <input type="hidden" id="hidden-transaction-amount" name="amount" value="<#if transaction.getAmount()??>${transaction.getAmount()}</#if>">
    </div>

    <script>
        amountValidationMessage = "${locale.getString("warning.transaction.amount")}";
        numberValidationMessage = "${locale.getString("warning.transaction.number")}";
    </script>
</#macro>

<#import "../categories/categoriesFunctions.ftl" as categoriesFunctions>
<#macro categorySelect categories selectedCategory inputClasses labelText>
    <div class="row">
        <div class="input-field ${inputClasses}" id="categoryWrapper">
            <select id="transaction-category" name="category" <@validation.validation "category"/>>
                <#list categories as category>
                    <#assign categoryInfos=categoriesFunctions.getCategoryName(category) + "@@@" + category.getColor() + "@@@" + category.getAppropriateTextColor() + "@@@" + category.getID()?c>

                    <#if category.getType() == "REST">
                        <#continue>
                    </#if>

                    <#if selectedCategory??>
                        <#if selectedCategory.getID()?c == category.getID()?c>
                            <option selected value="${category.getID()?c}">${categoryInfos}</option>
                        <#else>
                            <option value="${category.getID()?c}">${categoryInfos}</option>
                        </#if>
                        <#continue>
                    </#if>

                    <#if category.getType() == "NONE">
                        <option selected value="${category.getID()?c}">${categoryInfos}</option>
                        <#continue>
                    </#if>

                    <option value="${category.getID()?c}">${categoryInfos}</option>
                </#list>
            </select>
            <label for="transaction-category">${labelText}</label>
        </div>
    </div>

    <#-- pass selected category to JS in order to select current value for materialize select -->
    <script>
        <#if selectedCategory??>
        selectedCategory = "${selectedCategory.getID()?c}";
        <#else>
        selectedCategory = "${helpers.getIDOfNoCatgeory()?c}";
        </#if>
    </script>
</#macro>

<#macro transactionStartDate transaction currentDate>
    <div class="row">
        <div class="input-field col s12 m12 l8 offset-l2">
            <#if transaction.getDate()??>
                <#assign startDate = dateService.getLongDateString(transaction.getDate())/>
            <#else>
                <#assign startDate = dateService.getLongDateString(currentDate)/>
            </#if>

            <input id="transaction-datepicker" type="text" class="datepicker" name="date" value="${startDate}">
            <label for="transaction-datepicker">${locale.getString("transaction.new.label.date")}</label>
        </div>
    </div>

     <script>
        startDate = "${startDate}".split(".");
        startDate = new Date(startDate[2], startDate[1]-1, startDate[0]);
    </script>
</#macro>

<#macro transactionDescription transaction>
    <div class="row">
        <div class="input-field col s12 m12 l8 offset-l2">
            <textarea id="transaction-description" class="materialize-textarea" name="description" <@validation.validation "description"/>><#if transaction.getDescription()??>${transaction.getDescription()}</#if></textarea>
            <label for="transaction-description">${locale.getString("transaction.new.label.description")}</label>
        </div>
    </div>
</#macro>

<#macro transactionTags transaction>
    <div class="row">
        <div class="col s12 m12 l8 offset-l2">
            <label class="chips-label" for="transaction-chips">${locale.getString("transaction.new.label.tags")}</label>
            <div id="transaction-chips" class="chips chips-placeholder chips-autocomplete"></div>
        </div>
        <div id="hidden-transaction-tags"></div>
        <script>
            var initialTags = [
                <#if transaction.getTags()??>
                <#list transaction.getTags() as tag>
                {tag: '${tag.getName()}'},
                </#list>
                </#if>
            ];
        </script>
    </div>

    <!-- Tag autocomplete -->
    <script>
        tagsPlaceholder = "${locale.getString("tagfield.placeholder")}";
        tagAutoComplete = {
            <#list helpers.getAllTags() as tag>
            '${tag.getName()}': null,
            </#list>
        }
    </script>
</#macro>

<#macro account accounts selectedAccount id name label>
    <div class="row">
        <div class="input-field col s12 m12 l8 offset-l2">
            <select id="${id}" name="${name}" <@validation.validation "account"/>>
                <#list accounts as account>
                    <#if (account.getType().name() != "CUSTOM")>
                        <#continue>
                    </#if>

                    <#if selectedAccount == account>
                        <option selected value="${account.getID()?c}">${account.getName()}</option>
                        <#continue>
                    </#if>

                    <option value="${account.getID()?c}">${account.getName()}</option>
                </#list>
            </select>
            <label for="${id}">${label}</label>
        </div>
    </div>
</#macro>

<#macro transactionRepeating transaction currentDate>
    <div class="row">
        <div class="col s12 m12 l8 offset-l2">
            ${locale.getString("transaction.new.label.repeating")}
        </div>
    </div>

    <@newTransactionMacros.repeatingModifier transaction/>

    <@newTransactionMacros.repeatingEndOption transaction currentDate/>
</#macro>

<#macro repeatingModifier transaction>
    <div class="row" id="transaction-repeating-modifier-row">
        <div class="input-field col s6 m6 l4 offset-l2">
            <input id="transaction-repeating-modifier" type="text" <@validation.validation "repeatingModifierNumber"/> value="<#if transaction.getRepeatingOption()??>${transaction.getRepeatingOption().getModifier().getQuantity()}</#if>">
            <label for="transaction-repeating-modifier">${locale.getString("transaction.new.label.repeating.all")}</label>
        </div>
        <input type="hidden" id="hidden-transaction-repeating-modifier" name="repeatingModifierNumber" value="<#if transaction.getRepeatingOption()??>${transaction.getRepeatingOption().getModifier().getQuantity()}</#if>">

        <div class="input-field col s6 m6 l4">
            <select id="transaction-repeating-modifier-type" name="repeatingModifierType">
                <#list helpers.getRepeatingModifierTypes() as modifierType>
                    <#assign modifierName=locale.getString(modifierType.getLocalizationKey())>
                    <#if transaction.getRepeatingOption()??>
                        ${transaction.getRepeatingOption().getModifier().getLocalizationKey()}
                        <#if locale.getString(transaction.getRepeatingOption().getModifier().getLocalizationKey()) == modifierName>
                            <option selected value="${modifierName}">${modifierName}</option>
                        <#else>
                            <option value="${modifierName}">${modifierName}</option>
                        </#if>
                    <#else>
                        <option value="${modifierName}">${modifierName}</option>
                    </#if>
                </#list>
            </select>
        </div>
    </div>
</#macro>

<#macro repeatingEndOption transaction currentDate>
    <div class="row" id="transaction-repeating-end">
        <div class="col s12 m12 l8 offset-l2">
            <div class="row">
                <div class="col s12 left-align">
                    ${locale.getString("repeating.end")}
                </div>
            </div>
            <@repeatingEndNever (transaction.getRepeatingOption()?? && transaction.getRepeatingOption().getEndOption().getLocalizationKey() == "repeating.end.key.never") || !transaction.getRepeatingOption()??/>
            <@repeatingEndAfterXTimes transaction.getRepeatingOption()?? && transaction.getRepeatingOption().getEndOption().getLocalizationKey() == "repeating.end.key.afterXTimes"/>
            <@repeatingEndDate transaction.getRepeatingOption()?? && transaction.getRepeatingOption().getEndOption().getLocalizationKey() == "repeating.end.key.date" transaction currentDate/>
            <input type="hidden" id="hidden-transaction-repeating-end-value" name="repeatingEndValue" value="">
        </div>
    </div>
</#macro>

<#macro repeatingEndNever checked>
    <div class="row valign-wrapper">
        <div class="col s1">
            <label>
                <input class="with-gap" name="repeatingEndType" type="radio" id="repeating-end-never" value="${locale.getString("repeating.end.key.never")}" <#if checked>checked</#if>/>
                <span for="repeating-end-never"></span>
            </label>
        </div>
        <div class="col s11">
            ${locale.getString("repeating.end.never")}
        </div>
    </div>
</#macro>

<#macro repeatingEndAfterXTimes checked>
    <div class="row valign-wrapper">
        <div class="col s1">
            <label>
                <input class="with-gap" name="repeatingEndType" type="radio" id="repeating-end-after-x-times" value="${locale.getString("repeating.end.key.afterXTimes")}" <#if checked>checked</#if>/>
                <span for="repeating-end-after-x-times"></span>
            </label>
        </div>
        <div class="col s11">
            <table class="table-repeating-end no-border-table">
                <tr>
                    <td class="cell">${locale.getString("repeating.end.afterXTimes.A")}</td>
                    <td class="cell input-cell">
                        <div class="input-field no-margin">
                            <input class="no-margin input-min-width" id="transaction-repeating-end-after-x-times-input" type="text" value="<#if checked>${transaction.getRepeatingOption().getEndOption().getValue()}</#if>">
                            <label for="transaction-repeating-end-after-x-times-input"></label>
                        </div>
                    </td>
                    <td class="cell stretched-cell">${locale.getString("repeating.end.afterXTimes.B")}</td>
                </tr>
            </table>
        </div>
    </div>
</#macro>

<#macro repeatingEndDate checked transaction currentDate>
    <#if checked>
        <#global endDate = dateService.getLongDateString(transaction.getRepeatingOption().getEndOption().getValue())/>
    <#else>
        <#global endDate = dateService.getLongDateString(currentDate)/>
    </#if>

    <script>
        endDate = "${endDate}".split(".");
        endDate = new Date(endDate[2], endDate[1]-1, endDate[0]);
    </script>

    <div class="row valign-wrapper">
        <div class="col s1">
            <label>
                <input class="with-gap" name="repeatingEndType" type="radio" id="repeating-end-date" value="${locale.getString("repeating.end.key.date")}" <#if checked>checked</#if>/>
                <span for="repeating-end-date"></span>
            </label>
        </div>
        <div class="col s11">
            <table class="table-repeating-end no-border-table">
                <tr>
                    <td class="cell">${locale.getString("repeating.end.date")}</td>
                    <td class="cell input-cell">
                        <div class="input-field no-margin">
                            <input class="datepicker no-margin input-min-width" id="transaction-repeating-end-date-input" type="text" value="${endDate}">
                            <label for="transaction-repeating-end-date-input"></label>
                        </div>
                    </td>
                    <td class="cell stretched-cell"></td>
                </tr>
            </table>
        </div>
    </div>
</#macro>

<#macro buttons>
    <div class="row hide-on-small-only">
        <div class="col s6 right-align">
            <@buttonCancel/>
        </div>

        <div class="col s6 left-align">
            <@buttonSave/>
        </div>
    </div>

    <div class="hide-on-med-and-up">
        <div class="row center-align">
            <div class="col s12">
                <@buttonCancel/>
            </div>
        </div>
        <div class="row center-align">
            <div class="col s12">
                <@buttonSave/>
            </div>
        </div>
    </div>
</#macro>

<#macro buttonCancel>
    <a href="<@s.url '/transactions'/>" class="waves-effect waves-light btn budgetmaster-blue"><i class="material-icons left">clear</i>${locale.getString("cancel")}</a>
</#macro>

<#macro buttonSave>
    <button class="btn waves-effect waves-light budgetmaster-blue" type="submit" name="action">
        <i class="material-icons left">save</i>${locale.getString("save")}
    </button>
</#macro>