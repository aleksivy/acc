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
	УстановитьПараметр(КомпоновщикНастроек, "Дата", КонецДня(ДатаОтчета) + 1 );
	УстановитьПараметр(КомпоновщикНастроек, "ПапкаГруппы", ПапкаГруппы );
	УстановитьПараметр(КомпоновщикНастроек, "НДС6412", НДС6412 );
	УстановитьПараметр(КомпоновщикНастроек, "СписокСчетовИсключений", ИсключаемыеСчета.ВыгрузитьКолонку("Счет") );
КонецПроцедуры

Процедура ПриОткрытии()
	Если Не ЗначениеЗаполнено(ДатаОтчета) Тогда ДатаОтчета = КонецМесяца( ТекущаяДата() ); КонецЕсли;
	Если Не ЗначениеЗаполнено(ПапкаГруппы) Тогда ПапкаГруппы = Справочники.Контрагенты.НайтиПоНаименованию("Group", Истина); КонецЕсли;
	Если Не ЗначениеЗаполнено(НДС6412) Тогда НДС6412 = Справочники.Налоги.НайтиПоНаименованию("НДС (для счета 6412)", Истина); КонецЕсли;
	Если Не ЗначениеЗаполнено(НДС6412) Тогда Сообщить("Не найден налог 'НДС (для счета 6412)'"); КонецЕсли;
	Если ИсключаемыеСчета.Количество()=0 Тогда
		лСтрока = ИсключаемыеСчета.Добавить(); лСтрока.Счет = ПланыСчетов.МСФО.НайтиПоКоду( "15" );
		лСтрока = ИсключаемыеСчета.Добавить(); лСтрока.Счет = ПланыСчетов.МСФО.НайтиПоКоду( "20" );
		лСтрока = ИсключаемыеСчета.Добавить(); лСтрока.Счет = ПланыСчетов.МСФО.НайтиПоКоду( "70" );
		лСтрока = ИсключаемыеСчета.Добавить(); лСтрока.Счет = ПланыСчетов.МСФО.НайтиПоКоду( "71" );
		лСтрока = ИсключаемыеСчета.Добавить(); лСтрока.Счет = ПланыСчетов.МСФО.НайтиПоКоду( "72" );
		лСтрока = ИсключаемыеСчета.Добавить(); лСтрока.Счет = ПланыСчетов.МСФО.НайтиПоКоду( "73" );
		лСтрока = ИсключаемыеСчета.Добавить(); лСтрока.Счет = ПланыСчетов.МСФО.НайтиПоКоду( "74" );
		лСтрока = ИсключаемыеСчета.Добавить(); лСтрока.Счет = ПланыСчетов.МСФО.НайтиПоКоду( "75" );
		лСтрока = ИсключаемыеСчета.Добавить(); лСтрока.Счет = ПланыСчетов.МСФО.НайтиПоКоду( "76" );
		лСтрока = ИсключаемыеСчета.Добавить(); лСтрока.Счет = ПланыСчетов.МСФО.НайтиПоКоду( "79" );
		лСтрока = ИсключаемыеСчета.Добавить(); лСтрока.Счет = ПланыСчетов.МСФО.НайтиПоКоду( "80" );
		лСтрока = ИсключаемыеСчета.Добавить(); лСтрока.Счет = ПланыСчетов.МСФО.НайтиПоКоду( "81" );
		лСтрока = ИсключаемыеСчета.Добавить(); лСтрока.Счет = ПланыСчетов.МСФО.НайтиПоКоду( "82" );
		лСтрока = ИсключаемыеСчета.Добавить(); лСтрока.Счет = ПланыСчетов.МСФО.НайтиПоКоду( "83" );
		лСтрока = ИсключаемыеСчета.Добавить(); лСтрока.Счет = ПланыСчетов.МСФО.НайтиПоКоду( "84" );
		лСтрока = ИсключаемыеСчета.Добавить(); лСтрока.Счет = ПланыСчетов.МСФО.НайтиПоКоду( "85" );
		лСтрока = ИсключаемыеСчета.Добавить(); лСтрока.Счет = ПланыСчетов.МСФО.НайтиПоКоду( "90" );
		лСтрока = ИсключаемыеСчета.Добавить(); лСтрока.Счет = ПланыСчетов.МСФО.НайтиПоКоду( "91" );
		лСтрока = ИсключаемыеСчета.Добавить(); лСтрока.Счет = ПланыСчетов.МСФО.НайтиПоКоду( "92" );
		лСтрока = ИсключаемыеСчета.Добавить(); лСтрока.Счет = ПланыСчетов.МСФО.НайтиПоКоду( "93" );
		лСтрока = ИсключаемыеСчета.Добавить(); лСтрока.Счет = ПланыСчетов.МСФО.НайтиПоКоду( "94" );
		лСтрока = ИсключаемыеСчета.Добавить(); лСтрока.Счет = ПланыСчетов.МСФО.НайтиПоКоду( "95" );
		лСтрока = ИсключаемыеСчета.Добавить(); лСтрока.Счет = ПланыСчетов.МСФО.НайтиПоКоду( "96" );
		лСтрока = ИсключаемыеСчета.Добавить(); лСтрока.Счет = ПланыСчетов.МСФО.НайтиПоКоду( "97" );
		лСтрока = ИсключаемыеСчета.Добавить(); лСтрока.Счет = ПланыСчетов.МСФО.НайтиПоКоду( "98" );
		лСтрока = ИсключаемыеСчета.Добавить(); лСтрока.Счет = ПланыСчетов.МСФО.НайтиПоКоду( "99" );
	КонецЕсли;
	
	УстановитьПараметрыОтборы();
КонецПроцедуры

Процедура ДатаОтчетаПриИзменении(Элемент)
	УстановитьПараметрыОтборы();
КонецПроцедуры

Процедура ПапкаГруппыПриИзменении(Элемент)
	УстановитьПараметрыОтборы();
КонецПроцедуры
