﻿
Процедура КоманднаяПанельДействиеПеречитать(Кнопка)

	Если ЗначениеЗаполнено(НалоговаяНакладная) Тогда
		Если Модифицированность и (Оплаты.Количество() > 0) Тогда
			
			Вопрос = "Измененные оплаты не были записаны! Продолжить?";
			Ответ  = Вопрос(Вопрос, РежимДиалогаВопрос.ОкОтмена);
			
			Если Не Ответ = КодВозвратаДиалога.ОК Тогда Возврат; КонецЕсли;
			ЗаписатьОплаты();
		КонецЕсли;
		
		ПрочитатьОплаты();
	КонецЕсли;

	Модифицированность = Ложь;

КонецПроцедуры

Процедура НалоговаяНакладнаяПриИзменении(Элемент)
	Если ЗначениеЗаполнено(НалоговаяНакладная) Тогда
		ЭлементыФормы.Оплаты.ТолькоПросмотр = Ложь;
		Контрагент = НалоговаяНакладная.Контрагент;
		ДоговорКонтрагента = НалоговаяНакладная.ДоговорКонтрагента;
		ПрочитатьОплаты();
	Иначе
		ЭлементыФормы.Оплаты.ТолькоПросмотр = Истина;
		Контрагент = Справочники.Контрагенты.ПустаяСсылка();
		ДоговорКонтрагента = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
		Оплаты.Очистить();
	КонецЕсли;
	Модифицированность = Ложь;
КонецПроцедуры

Процедура ПриОткрытии()
	НалоговаяНакладнаяПриИзменении("");
КонецПроцедуры

Процедура ДействияФормыДействиеЗаписать(Кнопка)
	Если ЗначениеЗаполнено(НалоговаяНакладная) Тогда
		ЗаписатьОплаты();
		Модифицированность = Ложь;
	КонецЕсли;
КонецПроцедуры

Процедура ОплатыПлатежноеПоручениеНачалоВыбора(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ФормаВыбора          = Документы.ПлатежноеПоручениеИсходящее.ПолучитьФормуВыбора(,Элемент,);
		
	ФормаВыбора.ДокументСписок.Отбор.Контрагент.ВидСравнения 	= ВидСравнения.Равно;
	ФормаВыбора.ДокументСписок.Отбор.Контрагент.Значение 		= Контрагент;
	ФормаВыбора.ДокументСписок.Отбор.Контрагент.Использование = Истина;
		
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		ФормаВыбора.ДокументСписок.Отбор.ДоговорКонтрагента.ВидСравнения 	= ВидСравнения.Равно;
		ФормаВыбора.ДокументСписок.Отбор.ДоговорКонтрагента.Значение 		= ДоговорКонтрагента;
		ФормаВыбора.ДокументСписок.Отбор.ДоговорКонтрагента.Использование = Истина;
	ИначеЕсли (НалоговаяНакладная.Товары.Количество() > 0) Тогда
		лсзДоговора = Новый СписокЗначений;
		лсзНомерДоговора = Новый СписокЗначений;
		лтзВрем = НалоговаяНакладная.Товары.Выгрузить(, "ДоговорКонтрагента");
		лтзВрем.Свернуть("ДоговорКонтрагента", "");
		Для каждого лСтрока Из лтзВрем Цикл
			лсзДоговора.Добавить( лСтрока.ДоговорКонтрагента );
			лсзНомерДоговора.Добавить( лСтрока.ДоговорКонтрагента.Номер );
		КонецЦикла;
		лсзДоговора.Добавить( Справочники.ДоговорыКонтрагентов.ПустаяСсылка() );
		ФормаВыбора.ДокументСписок.Отбор.ДоговорКонтрагента.ВидСравнения 	= ВидСравнения.ВСписке;
		ФормаВыбора.ДокументСписок.Отбор.ДоговорКонтрагента.Значение 		= лсзДоговора;
		ФормаВыбора.ДокументСписок.Отбор.ДоговорКонтрагента.Использование = Истина;
		ФормаВыбора.ДокументСписок.Отбор.ДоговорКонтрагентаНомер.ВидСравнения 	= ВидСравнения.ВСписке;
		ФормаВыбора.ДокументСписок.Отбор.ДоговорКонтрагентаНомер.Значение 		= лсзНомерДоговора;
		ФормаВыбора.ДокументСписок.Отбор.ДоговорКонтрагентаНомер.Использование = Истина;
	КонецЕсли;
	ФормаВыбора.ЭлементыФормы.ДокументСписок.ТекущаяСтрока = Элемент.Значение;
	ФормаВыбора.Открыть();
КонецПроцедуры

Процедура ОплатыПлатежноеПоручениеПриИзменении(Элемент)
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		ЭлементыФормы.Оплаты.Колонки.ДоговорКонтрагента.ТолькоПросмотр = Истина;
		Если Не ЭлементыФормы.Оплаты.ТекущиеДанные.ДоговорКонтрагента = ДоговорКонтрагента Тогда ЭлементыФормы.Оплаты.ТекущиеДанные.ДоговорКонтрагента = ДоговорКонтрагента; КонецЕсли;
		Если ЗначениеЗаполнено(Элемент.Значение) Тогда
			ЭлементыФормы.Оплаты.ТекущиеДанные.Сумма = Мин(Элемент.Значение.СуммаДокумента, НалоговаяНакладная.СуммаДокумента);
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(Элемент.Значение) Тогда
		Если ЗначениеЗаполнено(ЭлементыФормы.Оплаты.ТекущиеДанные.ДоговорКонтрагента) Тогда
			лДоговор = ЭлементыФормы.Оплаты.ТекущиеДанные.ДоговорКонтрагента;
			лОтбор = Новый Структура("ДоговорКонтрагента", лДоговор);
			лтзПлатеж = Элемент.Значение.РасшифровкаПлатежа.Выгрузить(лОтбор, "СуммаПлатежа");
			лтзПлатеж.Свернуть("", "СуммаПлатежа");
			лОтбор = Новый Структура("ДоговорКонтрагента", лДоговор);
			лтзТовары = НалоговаяНакладная.Товары.Выгрузить(лОтбор, "Сумма,СуммаНДС");
			лтзТовары.Свернуть("", "Сумма,СуммаНДС");
			Если (лтзПлатеж.Количество() > 0) и (лтзТовары.Количество() > 0) Тогда
				ЭлементыФормы.Оплаты.ТекущиеДанные.Сумма = Мин(лтзПлатеж[0].СуммаПлатежа, лтзТовары[0].Сумма + лтзТовары[0].СуммаНДС);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ОплатыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		ЭлементыФормы.Оплаты.Колонки.ДоговорКонтрагента.ТолькоПросмотр = Истина;
		Если Не ЭлементыФормы.Оплаты.ТекущиеДанные.ДоговорКонтрагента = ДоговорКонтрагента Тогда ЭлементыФормы.Оплаты.ТекущиеДанные.ДоговорКонтрагента = ДоговорКонтрагента; КонецЕсли;
	Иначе	
		ЭлементыФормы.Оплаты.Колонки.ДоговорКонтрагента.ТолькоПросмотр = Ложь;
	КонецЕсли;
КонецПроцедуры

Процедура ОплатыДоговорКонтрагентаПриИзменении(Элемент)
	Если ЗначениеЗаполнено(ЭлементыФормы.Оплаты.ТекущиеДанные.ДоговорКонтрагента) и ЗначениеЗаполнено(ЭлементыФормы.Оплаты.ТекущиеДанные.ПлатежноеПоручение) Тогда
		лДоговор = ЭлементыФормы.Оплаты.ТекущиеДанные.ДоговорКонтрагента;
		лОтбор = Новый Структура("ДоговорКонтрагента", лДоговор);
		лтзПлатеж = ЭлементыФормы.Оплаты.ТекущиеДанные.ПлатежноеПоручение.РасшифровкаПлатежа.Выгрузить(лОтбор, "СуммаПлатежа");
		лтзПлатеж.Свернуть("", "СуммаПлатежа");
		лОтбор = Новый Структура("ДоговорКонтрагента", лДоговор);
		лтзТовары = НалоговаяНакладная.Товары.Выгрузить(лОтбор, "Сумма,СуммаНДС");
		лтзТовары.Свернуть("", "Сумма,СуммаНДС");
		Если (лтзПлатеж.Количество() > 0) и (лтзТовары.Количество() > 0) Тогда
			ЭлементыФормы.Оплаты.ТекущиеДанные.Сумма = Мин(лтзПлатеж[0].СуммаПлатежа, лтзТовары[0].Сумма + лтзТовары[0].СуммаНДС);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура НалоговаяНакладнаяНачалоВыбора(Элемент, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(НалоговаяНакладная) и Модифицированность и (Оплаты.Количество() > 0) Тогда
		Вопрос = "Измененные оплаты не были записаны! Продолжить?";
		Ответ  = Вопрос(Вопрос, РежимДиалогаВопрос.ОкОтмена);
		Если Ответ = КодВозвратаДиалога.ОК Тогда 
			ЗаписатьОплаты();
		КонецЕсли;
	КонецЕсли;
	Модифицированность = Ложь;
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(НалоговаяНакладная) и Модифицированность и (Оплаты.Количество() > 0) Тогда
		Вопрос = "Измененные оплаты не были записаны! Продолжить?";
		Ответ  = Вопрос(Вопрос, РежимДиалогаВопрос.ОкОтмена);
		Если Ответ = КодВозвратаДиалога.ОК Тогда 
			ЗаписатьОплаты();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
