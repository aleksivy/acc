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
	УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(НачалоПериода) );
	УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(КонецПериода) );
КонецПроцедуры

Процедура ПриОткрытии()
	Если Не ЗначениеЗаполнено(НачалоПериода) Тогда НачалоПериода = НачалоМесяца(НачалоМесяца(ТекущаяДата())-1); КонецЕсли;
	Если Не ЗначениеЗаполнено(КонецПериода) Тогда КонецПериода = КонецМесяца(НачалоМесяца(ТекущаяДата())-1); КонецЕсли;
	УстановитьПараметрыОтборы();
КонецПроцедуры

Процедура ДатаОтчетаПриИзменении(Элемент)
	УстановитьПараметрыОтборы();
КонецПроцедуры

Процедура КонецПериодаПриИзменении(Элемент)
	УстановитьПараметрыОтборы();
КонецПроцедуры
