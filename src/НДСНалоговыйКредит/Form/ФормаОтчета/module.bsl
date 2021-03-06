﻿// УстановитьОтбор
//
Процедура УстановитьОтбор(КомпоновщикНастроек, ИмяПараметра, ЗначениеПараметра, пВидСравнения=Неопределено)
	ЭлементОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПараметра);
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
	Если ЗначениеЗаполнено(ЗначениеПараметра) Тогда
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ПравоеЗначение = ЗначениеПараметра;	
		Если Не (пВидСравнения = Неопределено) Тогда
			ЭлементОтбора.ВидСравнения = пВидСравнения;
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
	КомпоновщикНастроек.Настройки.Отбор.Элементы.Очистить();
	Если ЗначениеЗаполнено(Контрагент) Тогда УстановитьОтбор(КомпоновщикНастроек, "Контрагент", Контрагент ); КонецЕсли;
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда УстановитьОтбор(КомпоновщикНастроек, "ДоговорКонтрагента", ДоговорКонтрагента ); КонецЕсли;
	Если ЗначениеЗаполнено(СтатьяДекларацииНДСНалоговыйКредит) Тогда УстановитьОтбор(КомпоновщикНастроек, "СтатьяДекларацииНДСНалоговыйКредит", СтатьяДекларацииНДСНалоговыйКредит ); КонецЕсли;
	Если ЗначениеЗаполнено(СтавкаНДС) Тогда УстановитьОтбор(КомпоновщикНастроек, "СтавкаНДС", СтавкаНДС ); КонецЕсли;
	
	Если ЗначениеЗаполнено(НачалоПериода) Тогда УстановитьОтбор(КомпоновщикНастроек, "Период", НачалоДня(НачалоПериода), ВидСравненияКомпоновкиДанных.БольшеИлиРавно ); КонецЕсли;
	Если ЗначениеЗаполнено(КонецПериода) Тогда УстановитьОтбор(КомпоновщикНастроек, "Период", КонецДня(КонецПериода), ВидСравненияКомпоновкиДанных.МеньшеИлиРавно ); КонецЕсли;
	
КонецПроцедуры

Процедура ПриОткрытии()
	УстановитьПараметрыОтборы();
КонецПроцедуры

Процедура НачалоПериодаПриИзменении(Элемент)
	УстановитьПараметрыОтборы();
КонецПроцедуры

Процедура КонецПериодаПриИзменении(Элемент)
	УстановитьПараметрыОтборы();
КонецПроцедуры

Процедура СтавкаНДСПриИзменении(Элемент)
	УстановитьПараметрыОтборы();
КонецПроцедуры

Процедура КонтрагентПриИзменении(Элемент)
	УстановитьПараметрыОтборы();
КонецПроцедуры

Процедура ДоговорКонтрагентаПриИзменении(Элемент)
	УстановитьПараметрыОтборы();
КонецПроцедуры

Процедура СтатьяДекларацииНДСНалоговыйКредитПриИзменении(Элемент)
	УстановитьПараметрыОтборы();
КонецПроцедуры
