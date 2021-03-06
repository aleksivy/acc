﻿// УстановитьОтбор
//
Процедура УстановитьОтбор(КомпоновщикНастроек, ИмяПараметра, ЗначениеПараметра)
	ЭлементОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПараметра);
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
	Если ЗначениеЗаполнено(ЗначениеПараметра) Тогда
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ПравоеЗначение = ЗначениеПараметра;	
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
	Иначе
		ЭлементОтбора.Использование = Ложь;
	КонецЕсли;
КонецПроцедуры

// УстановитьПараметр
//
Процедура УстановитьПараметр(КомпоновщикНастроек, ИмяПараметра, ЗначениеПараметра)
	ПараметрДанныхТекущий = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	ПараметрДанныхТекущий.Значение = ЗначениеПараметра;
	ПараметрДанныхТекущий.Использование = ЗначениеЗаполнено(ЗначениеПараметра);
КонецПроцедуры

Процедура УстановитьПараметрыОтборы()
	УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", ?(ЗначениеЗаполнено(НачалоПериода), НачалоДня(НачалоПериода), НачалоПериода) );
	УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", ?(ЗначениеЗаполнено(КонецПериода), КонецДня(КонецПериода), КонецПериода) );
	
	КомпоновщикНастроек.Настройки.Отбор.Элементы.Очистить();
	УстановитьОтбор(КомпоновщикНастроек, "Регистратор", Документ );
КонецПроцедуры

Процедура ПриОткрытии()
	Если ЗначениеЗаполнено(Документ) Тогда
		УстановитьПараметрыОтборы();
		ДанныеРасшифровкиОсновная = Новый ДанныеРасшифровкиКомпоновкиДанных;
		ЭтотОбъект.СкомпоноватьРезультат(ЭлементыФормы.Результат, ДанныеРасшифровкиОсновная); 
	КонецЕсли;
КонецПроцедуры

Процедура ДокументПриИзменении(Элемент)
	УстановитьПараметрыОтборы();
КонецПроцедуры

Процедура НачалоПериодаПриИзменении(Элемент)
	УстановитьПараметрыОтборы();
КонецПроцедуры

Процедура КонецПериодаПриИзменении(Элемент)
	УстановитьПараметрыОтборы();
КонецПроцедуры
