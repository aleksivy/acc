﻿// УстановитьОтбор
//
Процедура УстановитьОтбор(КомпоновщикНастроек, ИмяПараметра, ЗначениеПараметра)
	ЭлементОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПараметра);
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ПравоеЗначение = ЗначениеПараметра;
	Если ТипЗнч(ЗначениеПараметра) = Тип("СписокЗначений") Тогда
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
	Иначе
		Попытка
			лЭтоГруппа = ЗначениеПараметра.ЭтоГруппа;
			Если лЭтоГруппа Тогда
				ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
			Иначе
				ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			КонецЕсли;
		Исключение
			ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		КонецПопытки;
	КонецЕсли;
КонецПроцедуры

// УстановитьПараметр
//
Процедура УстановитьПараметр(КомпоновщикНастроек, ИмяПараметра, ЗначениеПараметра)
	ПараметрДанныхТекущий = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	ПараметрДанныхТекущий.Значение = ЗначениеПараметра;
	ПараметрДанныхТекущий.Использование = Истина;
КонецПроцедуры

Процедура УстановитьПараметрыОтборы()
	Если Не ЗначениеЗаполнено(ДатаНач) Тогда ДатаНач = НачалоМесяца(НачалоМесяца( ТекущаяДата() )-1); КонецЕсли;
	Если Не ЗначениеЗаполнено(ДатаКон) или ДатаКон < ДатаНач Тогда ДатаКон = КонецМесяца(ДатаНач); КонецЕсли;
	
	УстановитьПараметр(КомпоновщикНастроек, "ДатаНач", ДатаНач );
	УстановитьПараметр(КомпоновщикНастроек, "ДатаКон", ДатаКон );
КонецПроцедуры

Процедура ПриОткрытии()
	Если Не ЗначениеЗаполнено(ДатаНач) Тогда ДатаНач = НачалоМесяца(НачалоМесяца( ТекущаяДата() )-1); КонецЕсли;
	Если Не ЗначениеЗаполнено(ДатаКон) или ДатаКон < ДатаНач Тогда ДатаКон = КонецМесяца(ДатаНач); КонецЕсли;
	
	УстановитьПараметрыОтборы();
КонецПроцедуры

Процедура ДатаНачПриИзменении(Элемент)
	Если ЗначениеЗаполнено(ДатаНач) Тогда ДатаКон = КонецМесяца(ДатаНач); КонецЕсли;
	
	УстановитьПараметрыОтборы();
КонецПроцедуры

Процедура ДатаКонПриИзменении(Элемент)
	Если ДатаКон < ДатаНач Тогда ДатаКон = КонецМесяца(ДатаНач); КонецЕсли;
	
	УстановитьПараметрыОтборы();
КонецПроцедуры
