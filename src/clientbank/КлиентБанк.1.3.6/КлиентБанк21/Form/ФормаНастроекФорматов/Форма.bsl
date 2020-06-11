﻿// (С) АБИ Украина 2013

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	КопироватьДанныеФормы(Параметры.Ключ, Объект);
	МетаПуть = РеквизитФормыВЗначение("Объект").Метаданные().ПолноеИмя();
	сооМФОФормат = Параметры.сооМФОФормат;
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьЗапросНаФайлы(Команда)
	ПараметрыФормы = Новый Структура("Ключ", Объект);
	Настройки = Неопределено;

	ОткрытьФорму(МетаПуть + ".Форма.ФормаЗапросаФайлов", ПараметрыФормы, ЭтаФорма,,,, Новый ОписаниеОповещения("ОтправитьЗапросНаФайлыЗавершение", ЭтаФорма)); 
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьЗапросНаФайлыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	//^<< szewczuk 01.11.2016
	//^Настройки = ОткрытьФормуМодально(МетаПуть + ".Форма.ФормаЗапросаФайлов", ПараметрыФормы, ЭтаФорма);
	Настройки = Результат;
	//^>>

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПоСчету(Команда)
	
	ВыбраннаяОрганизация = Неопределено;
	
	ОткрытьФорму("Справочник.Организации.ФормаВыбора",,,,,, Новый ОписаниеОповещения("ДобавитьПоСчетуЗавершение", ЭтаФорма));
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПоСчетуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	//^<< szewczuk 02.11.2016
	//^ВыбраннаяОрганизация = ОткрытьФормуМодально("Справочник.Организации.ФормаВыбора");
	//^>>
	
	ВыбраннаяОрганизация = Результат;
	Если ВыбраннаяОрганизация = Неопределено  Тогда
		Возврат;
	КонецЕсли;
	
	//^<< szewczuk 02.11.2016
	Если Объект.Конфигурация = "УТ" Тогда
	//^>>	
		ВыбранныйСчет = Неопределено;
	//^<< szewczuk 02.11.2016	
		ОткрытьФорму("Справочник.БанковскиеСчетаОрганизаций.ФормаВыбора", Новый Структура("Отбор", Новый Структура("Владелец", ВыбраннаяОрганизация)),,,,, Новый ОписаниеОповещения("ДобавитьПоСчетуЗавершениеЗавершениеУТ", ЭтаФорма));
		
	ИначеЕсли Объект.Конфигурация = "БУ" Тогда
		
		ВыбранныйСчет = Неопределено;
		ОткрытьФорму("Справочник.БанковскиеСчета.ФормаВыбора", Новый Структура("Отбор", Новый Структура("Владелец", ВыбраннаяОрганизация)),,,,, Новый ОписаниеОповещения("ДобавитьПоСчетуЗавершениеЗавершениеБУ", ЭтаФорма));
		
	КонецЕсли; 
	//^>>
	
КонецПроцедуры

//^<< szewczuk 02.11.2016
&НаКлиенте
Процедура ДобавитьПоСчетуЗавершениеЗавершениеУТ(Результат1, ДополнительныеПараметры1) Экспорт
	
	//^<< szewczuk 02.11.2016
	//^ВыбранныйСчет = ОткрытьФормуМодально("Справочник.БанковскиеСчетаОрганизаций.ФормаВыбора", Новый Структура("Отбор", Новый Структура("Владелец", ВыбраннаяОрганизация)));
	ВыбранныйСчет = Результат1;
	//^>> 
	
	
	Если ВыбранныйСчет = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	ДобавитьФорматОбмена(ВыбранныйСчет, "");

КонецПроцедуры
//^>>

//^<< szewczuk 02.11.2016
&НаКлиенте
Процедура ДобавитьПоСчетуЗавершениеЗавершениеБУ(Результат1, ДополнительныеПараметры1) Экспорт
	
	//^<< szewczuk 02.11.2016
	//^ВыбранныйСчет = ОткрытьФормуМодально("Справочник.БанковскиеСчета.ФормаВыбора", Новый Структура("Отбор", Новый Структура("Владелец", ВыбраннаяОрганизация)));
	ВыбранныйСчет = Результат1;
	//^>> 
	
	Если ВыбранныйСчет = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	ДобавитьФорматОбмена(ВыбранныйСчет, "");

КонецПроцедуры
//^>>

&НаКлиенте
Процедура ЗаполнитьПоСчетам(Команда)
	// спрашиваем - очистить таблицу или добавить к существующим форматам
	Если Объект.тчИспользуемыеФорматыОбмена.Количество() > 0 Тогда
		Очистить = Неопределено;
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьПоСчетамЗавершение", ЭтаФорма),НСТР("ru='Очистить таблицу используемых форматов?';uk='Очистити таблицю використовуваних форматів?'"), РежимДиалогаВопрос.ДаНет,,,,);
        Возврат; 
	КонецЕсли;
	
	//^<< szewczuk 02.11.2016 Вызов нужен для заполнении по счетам если таблица пустая
	ЗаполнитьПоСчетамФрагмент();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоСчетамЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	//^<< szewczuk 02.11.2016
	//^Очистить = Вопрос(НСТР("ru='Очистить таблицу используемых форматов?';uk='Очистити таблицю використовуваних форматів?'"), РежимДиалогаВопрос.ДаНет);
	Очистить = РезультатВопроса;
	Если Очистить = КодВозвратаДиалога.Да Тогда
		Объект.тчИспользуемыеФорматыОбмена.Очистить();
	КонецЕсли;
	//^>>; 
	
	ЗаполнитьПоСчетамФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоСчетамФрагмент()
	
	ЗаполнитьПоСчетамСервер();

КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	// формируем новый файл clientbank.ini
	ЗаписатьИспользуемыеФорматыОбмена();
	Закрыть(Истина);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
// Добавляет указанный формат обмена в тчИспользуемыеФорматыОбмена
// ИмяФайла и СуществуетФайл берем с тчИспользуемыеФорматыОбмена
//
// Параметры:
//
//  СчетОрганизации – Банковский счет организации
//  или 
//  МФО             – МФО банка
//
Процедура ДобавитьФорматОбмена(СчетОрганизации = Неопределено, МФО = "")
	
	Если СчетОрганизации <> Неопределено И ПустаяСтрока(МФО) Тогда
		МФО = СокрЛП(СчетОрганизации.Банк.Код);
	КонецЕсли;
	
	Если ПустаяСтрока(МФО) Тогда
		Возврат;
	КонецЕсли;	
	
	ИмяФорматаОбмена = Неопределено;
	Если ЗначениеЗаполнено(сооМФОФормат) Тогда
		ФорматОбменаСтрока = сооМФОФормат.НайтиПоЗначению(МФО);
		ИмяФорматаОбмена = ?(ФорматОбменаСтрока = Неопределено, "", ФорматОбменаСтрока.Представление);
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ИмяФорматаОбмена) Тогда
		// заполняем таблицу, если соответствия нет, сообщаем в окно сообщений
		// проверим, не было ли уже такого формата в таблице
		СтрокаИспользуемыеФорматы = Объект.тчИспользуемыеФорматыОбмена.Выгрузить().Найти(ИмяФорматаОбмена, "ИмяФормата");
		Если СтрокаИспользуемыеФорматы <> Неопределено Тогда
			// строка с таким форматом уже есть в таблице 
			Возврат;
		КонецЕсли;
		СтрокаВсеФорматыОбмена = Объект.тчВсеФорматыОбмена.Выгрузить().Найти(ИмяФорматаОбмена, "ИмяФормата");
		Если СтрокаВсеФорматыОбмена <> Неопределено Тогда
			СтрокаИспользуемыеФорматы = Объект.тчИспользуемыеФорматыОбмена.Добавить();
			СтрокаИспользуемыеФорматы.ИмяФормата = ИмяФорматаОбмена;
			СтрокаИспользуемыеФорматы.ИмяФайла = СтрокаВсеФорматыОбмена.ИмяФайла;
			СтрокаИспользуемыеФорматы.СуществуетФайл = СтрокаВсеФорматыОбмена.СуществуетФайл;
		КонецЕсли;	
	Иначе
		Сообщить(НСТР("ru='Не найдено соответствующего формата для банка с МФО ';uk='Не знайдено відповідного формату для банку з МФО '") + МФО);
	КонецЕсли;
КонецПроцедуры // ДобавитьФорматОбмена()

&НаСервере
Процедура ЗаполнитьПоСчетамСервер()
	
	
	Запрос = Новый Запрос;
	//^<< szewczuk 02.11.2016
	Если Объект.Конфигурация = "УТ" Тогда
	//^>>
		Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	БанковскиеСчетаОрганизаций.Банк.Код КАК МФО
	               |ИЗ
	               |	Справочник.БанковскиеСчетаОрганизаций КАК БанковскиеСчетаОрганизаций";
	//^<< szewczuk 02.11.2016
	ИначеЕсли  Объект.Конфигурация = "БУ" Тогда 
		 Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	БанковскиеСчета.Банк.Код КАК МФО
	               |ИЗ
	               |	Справочник.БанковскиеСчета КАК БанковскиеСчета";
	КонецЕсли; 
	//^>>
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ДобавитьФорматОбмена(Неопределено, СокрЛП(Выборка.МФО));
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
// Записует используемые форматы обмена из тчИспользуемыеФорматыОбмена в файл ClientBank.ini
//
// Параметры: нет
//
//
// Возвращаемое значение:
//
//   Булево   – Истина при удачной записи
//
// 
Функция ЗаписатьИспользуемыеФорматыОбмена()
	ИмяКаталогаКБ = Объект.НастройкаИмяКаталогаКБ;
	ФайлИФ = Новый ТекстовыйДокумент();
	ИмяФайлаИФ = ИмяКаталогаКБ + "ClientBank.ini";
	
	// по строкам тчИспользуемыеФорматыОбмена
	Для Каждого СтрокатчИФО Из Объект.тчИспользуемыеФорматыОбмена Цикл
		ФайлИФ.ДобавитьСтроку(СтрокатчИФО.ИмяФормата + ";" + СтрокатчИФО.ИмяФайла);
	КонецЦикла; 
	Попытка
		ФайлИФ.Записать(ИмяФайлаИФ, КодировкаТекста.ANSI);
		Возврат Истина;
	Исключение
		Возврат Ложь;
	КонецПопытки;
КонецФункции // ЗаписатьИспользуемыеФорматыОбмена()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ФОРМЫ

&НаКлиенте
Процедура тчИспользуемыеФорматыОбменаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры



