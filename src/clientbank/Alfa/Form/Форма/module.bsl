﻿Перем ИмяФормата;

// Отказ от открытия обработки, выдаем сообщение о "служебности" обработки
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	Предупреждение("Обработка вызывается только из ПП ""Обмен информацией между ПП ""1С:Предприятие 8.0"" и системами ""Клиент-Банк""");
	Отказ = Истина;
КонецПроцедуры

// Возвращает Истина, если код в банке есть, Ложь - иначе
//
// Параметры: нет
//
// Возвращаемое значение:
//
//   Булево   – Истина, если код в банке есть, Ложь - иначе
//
Функция ЕстьКодВБанке() Экспорт
	Возврат Ложь;
КонецФункции	
	
// Возвращает наименование кода в банке
//
// Параметры:
//
//	нет
//
// Возвращаемое значение:
//
// 	Строка - наименование кода
//
Функция ПолучитьНаименованиеКода() Экспорт
	Возврат "";
КонецФункции		

// Возвращает код банка организации
//
// Параметры:
//
//  Структура Параметры
// 		Ключ Организация - Организация - Справочник.Ссылки.Организация          
//
// Возвращаемое значение:
//
//   Строка   – код организации в банке
//
Функция кбПолучитьКодОрганизации(Параметры) Экспорт
	Возврат "";
КонецФункции

// Возвращает по имени файла каталог
//
// Параметры:
//
//  Файл - имя файла - строка
//
// Возвращаемое значение:
//
//   Строка – каталог
//
Функция ПолучитьКаталог(Файл)
	Если Файл = Неопределено Тогда
		Возврат "";
	КонецЕсли;	
	ИмяФайла = Файл;
	
	Каталог = "";
	поз = Найти(ИмяФайла, "\");
	Пока поз Цикл
		Каталог = Каталог + Лев(ИмяФайла, поз);
		ИмяФайла = Сред(ИмяФайла, поз + 1);
		поз = Найти(ИмяФайла, "\");
	КонецЦикла;	
	Возврат Каталог;
	
КонецФункции	

// Формирует имя файла по умолчанию
//
// Параметры:
//
// 	Структура Параметры
//		Ключ Режим - Режим - Строка "Импорт"/"Экспорт"
// 		Ключ Дата -  Дата выписки (импорт) - Дата
// 		Ключ Организация - Организация - Справочник.Ссылки.Организация          
// 		Ключ КодВБанке - код в банке (если есть) 
// 
// Возвращаемое значение:
//
//   имя файла по умолчанию
//
Функция СформироватьИмяФайла(Параметры) Экспорт 
	ИмяФайла = ВосстановитьЗначение(ИмяФормата + Параметры.Организация +  "ИмяФайла" + Параметры.Режим);
	Если Параметры.Режим = "Импорт" Тогда
		сФайл = Формат(Параметры.Дата, "ДФ=yyMMdd") + ".dbf";
		Каталог = ПолучитьКаталог(ИмяФайла);
		Возврат Каталог + сФайл;
	Иначе	
		Возврат "";
	КонецЕсли;	
КонецФункции

// Выбирает имя файла
//
// Параметры:
//
// 	Структура Параметры
//		Ключ Режим - Режим - Строка "Импорт"/"Экспорт"
// 		Ключ Дата -  Дата выписки (импорт) - Дата
// 		Ключ КодВБанке - код в банке (если есть) 
//      Ключ ТекущееИмяФайла - строка - текущее имя файла в основной обработке
//      Ключ ТекущийТипФайла - текущий тип файла ("TXT"/"DBF"/"XML")
//
// Возвращаемое значение:
//
//   Строка   – выбранное имя файла
//
Функция ВыбратьИмяФайла(Параметры) Экспорт
	
	РежимДиалога = ?(Параметры.Режим = "Импорт", РежимДиалогаВыбораФайла.Открытие, РежимДиалогаВыбораФайла.Сохранение);
	Длг = Новый ДиалогВыбораФайла(РежимДиалога);
	
	Длг.ПолноеИмяФайла = Параметры.ТекущееИмяФайла;
	Длг.Заголовок = "Выберите файл";
	Если Параметры.Режим = "Импорт" Тогда
		Длг.Фильтр = "Файлы dBase (*.dbf)|*.dbf";
		Длг.Расширение = "dbf";   //Параметры.ТекущийТипФайла;
	Иначе
		Длг.Фильтр = "Текстовые файлы (*.*)|*.*";
		Длг.Расширение = "*";   //Параметры.ТекущийТипФайла;
	КонецЕсли;	
	
	Если Длг.Выбрать() Тогда
		Возврат Длг.ПолноеИмяФайла;
	КонецЕсли;
	
	Возврат Параметры.ТекущееИмяФайла;
КонецФункции

// Возвращает сохраненный тип файла
//
// Параметры:
//
// 	Структура Параметры
//		Ключ Режим - Режим - Строка "Импорт"/"Экспорт"
// 		Ключ Организация - Организация - Справочник.Ссылки.Организация          
//
// Возвращаемое значение:
//
//   Строка – текущий тип файла ("TXT"/"DBF"/"XML")
//
Функция ПолучитьТекущийТипФайла(Параметры) Экспорт
	
	ТипФайла = ВосстановитьЗначение(ИмяФормата + Параметры.Организация +  "ТипФайла" + Параметры.Режим);
	
	Если Параметры.Режим = "Импорт" Тогда
		Если ТипФайла = Неопределено Тогда
			Возврат "DBF";
		Иначе
			Возврат ТипФайла;
		КонецЕсли;	
	Иначе 
		Параметры.Режим = "Экспорт";
		Если НЕ ЗначениеЗаполнено(ТипФайла) Тогда
			Возврат "TXT";
		Иначе
			Возврат ТипФайла;
		КонецЕсли;	
//		Возврат "";	
	КонецЕсли;	

КонецФункции

// Возвращает сохраненный кодировку файла
//
// Параметры:
//
// 	Структура Параметры
//		Ключ Режим - Режим - Строка "Импорт"/"Экспорт"
//
// Возвращаемое значение:
//
//   Строка – текущая кодировка файла ( "ANSI" / "OEM" )
//
Функция ПолучитьТекущуюКодировкуФайла(Параметры) Экспорт
	
	КодировкаФайла = ВосстановитьЗначение(ИмяФормата + Параметры.Организация +  "КодировкаФайла" + Параметры.Режим);
	
	Если Параметры.Режим = "Импорт" Тогда
		Если КодировкаФайла = Неопределено Тогда
			Возврат "ANSI"; // ANSI (Windows) или OEM (DOS)
		Иначе
			Возврат КодировкаФайла;
		КонецЕсли;	
	Иначе 
		// Параметры.Режим = "Экспорт"
		Если КодировкаФайла = Неопределено Тогда
			Возврат "ANSI"; // ANSI (Windows) или OEM (DOS)
		Иначе
			Возврат КодировкаФайла;
		КонецЕсли;	
	КонецЕсли;	

КонецФункции

// Сохраняет значения для формата:
//
//	Имя файла
// 	Тип файла 
// 	Код в банке, если такой существует
//
// Параметры:
// 		Структура Параметры
//		Ключ Режим - Режим - Строка "Импорт"/"Экспорт"
// 		Ключ Организация - Организация - Справочник.Ссылки.Организация          
// 		Ключ КодВБанке - код в банке (если есть) 
//      Ключ ТекущееИмяФайла - строка - текущее имя файла в основной обработке
//      Ключ ТекущийТипФайла - строка - текущий тип файла в основной обработке
//  
Процедура СохранитьЗначения(Параметры) Экспорт
	
	СохранитьЗначение(ИмяФормата + Параметры.Организация +  "ИмяФайла" + Параметры.Режим, Параметры.ТекущееИмяФайла);
	СохранитьЗначение(ИмяФормата + Параметры.Организация +  "ТипФайла" + Параметры.Режим, Параметры.ТекущийТипФайла);
	СохранитьЗначение(ИмяФормата + Параметры.Организация +  "КодировкаФайла" 	+ Параметры.Режим, Параметры.КодировкаФайла);
	Если ЕстьКодВБанке() Тогда 
		СохранитьЗначение(ИмяФормата + Параметры.Организация +  "КодВБанке", Параметры.КодВБанке); // если есть 
	КонецЕсли;	
	
КонецПроцедуры

// Обработка формата должна вернуть режимы и типы файлов, которая она поддерживает.
//
// Параметры: нет
//
//  Возвращаемое значение:
//
//	Возвращает структуру со следующими ключами:
//
//	Импорт (Истина/Ложь)
//	ИмпортTXT (Истина/Ложь)
//	ИмпортDBF (Истина/Ложь)
//	ИмпортXML (Истина/Ложь)
//	Экспорт (Истина/Ложь)
//	ЭкспортTXT (Истина/Ложь) 
//	ЭкспортDBF (Истина/Ложь)
//	ЭкспортXML (Истина/Ложь)
//
Функция ПолучитьПоддерживаемыеРежимы() Экспорт
	
	ИмпортЭкспорт = Новый Структура;
	ИмпортЭкспорт.Вставить("Импорт", Истина);
	ИмпортЭкспорт.Вставить("ИмпортTXT", Ложь);
	ИмпортЭкспорт.Вставить("ИмпортDBF", Истина);
	ИмпортЭкспорт.Вставить("ИмпортXML", Ложь);
	
	ИмпортЭкспорт.Вставить("Экспорт", Истина);
	ИмпортЭкспорт.Вставить("ЭкспортTXT", Истина);
	ИмпортЭкспорт.Вставить("ЭкспортDBF", Ложь);
	ИмпортЭкспорт.Вставить("ЭкспортXML", Ложь);
	
	Возврат ИмпортЭкспорт;
	
КонецФункции

// Осуществляет импорт выписки из файла типа "TXT"
//
// Параметры:
//
//	Структура Параметры   
//
// 		Ключ ДатаДок - Дата выписки  – дата 
// 		Ключ Организация - Организация - СправочникСсылка.Организации
//		Ключ РСчет - Расчетный счет организации - строка
//		Ключ ИмяФайла - Имя файла  - строка  
//		Ключ ТипФайла - Тип файла  - строка ("TXT"/"DBF"/"XML")
//
//
// Возвращаемое значение:
//
//   Таблица значений тзВыписка
//		
//		тзВыписка - Таблица платежей – таблица значений тзВыписка с полями 
//			НомерПП – строка, номер платежного поручения 
//			Приход – число, сумма прихода
//			Расход – число, сумма расхода
//			ОКПО – строка, ЕДРПОУ контрагента
//			Контрагент – строка, наименование контрагента, как оно указано в выписке
//			МФО - строка, МФО банка контрагента
//			РСчет - строка, расчетный счет контрагента
//			Содержание - строка, содержание платежа
//
//		Если при импорте выписки произошли ошибки, возвращается Неопределенно.
//      
//      При проверке на дату платежа, если платежей с датой, которая отличается от переданной было > 0
//      необходимо выдать предупреждение
//
Функция ИмпортTXT(Параметры)
	Возврат Неопределено;	
КонецФункции	

// Осуществляет импорт выписки из файла типа "XML"
//
// Параметры:
//
//	Структура Параметры   
//
// 		Ключ ДатаДок - Дата выписки  – дата 
// 		Ключ Организация - Организация - СправочникСсылка.Организации
//		Ключ РСчет - Расчетный счет организации - строка
//		Ключ ИмяФайла - Имя файла  - строка  
//		Ключ ТипФайла - Тип файла  - строка ("TXT"/"DBF"/"XML")
//
//
// Возвращаемое значение:
//
//   Таблица значений тзВыписка
//		
//		тзВыписка - Таблица платежей – таблица значений тзВыписка с полями 
//			НомерПП – строка, номер платежного поручения 
//			Приход – число, сумма прихода
//			Расход – число, сумма расхода
//			ОКПО – строка, ЕДРПОУ контрагента
//			Контрагент – строка, наименование контрагента, как оно указано в выписке
//			МФО - строка, МФО банка контрагента
//			РСчет - строка, расчетный счет контрагента
//			Содержание - строка, содержание платежа
//
//		Если при импорте выписки произошли ошибки, возвращается Неопределенно.
//      
//      При проверке на дату платежа, если платежей с датой, которая отличается от переданной было > 0
//      необходимо выдать предупреждение
//
Функция ИмпортXML(Параметры)
	Возврат Неопределено;	
КонецФункции	

// Осуществляет импорт выписки из файла типа "DBF"
//
// Параметры:
//
//	Структура Параметры   
//
// 		Ключ ДатаДок - Дата выписки  – дата 
// 		Ключ Организация - Организация - СправочникСсылка.Организации
//		Ключ РСчет - Расчетный счет организации - строка
//		Ключ ИмяФайла - Имя файла  - строка  
//		Ключ ТипФайла - Тип файла  - строка ("TXT"/"DBF"/"XML")
//
//
// Возвращаемое значение:
//
//   Таблица значений тзВыписка
//		
//		тзВыписка - Таблица платежей – таблица значений тзВыписка с полями 
//			НомерПП – строка, номер платежного поручения 
//			Приход – число, сумма прихода
//			Расход – число, сумма расхода
//			ОКПО – строка, ЕДРПОУ контрагента
//			Контрагент – строка, наименование контрагента, как оно указано в выписке
//			МФО - строка, МФО банка контрагента
//			РСчет - строка, расчетный счет контрагента
//			Содержание - строка, содержание платежа
//
//		Если при импорте выписки произошли ошибки, возвращается Неопределенно.
//      
//      При проверке на дату платежа, если платежей с датой, которая отличается от переданной было > 0
//      необходимо выдать предупреждение
//
Функция ИмпортDBF(Параметры)
	ФайлDBF = Новый XBase;
	ФайлDBF.Кодировка = КодировкаXBase[Параметры.КодировкаФайла];    //WIN
	
	ИмяФайла = Параметры.ИмяФайла;
	
	Попытка
		ФайлDBF.ОткрытьФайл(ИмяФайла,,Истина); //Только для чтения
	Исключение
		Предупреждение("Ошибка открытия файла " + ИмяФайла);
		Возврат Неопределено;
	КонецПопытки;		
	
	Если НЕ ФайлDBF.Открыта() Тогда
		Предупреждение("Ошибка открытия файла " + ИмяФайла);
		Возврат Неопределено;
	КонецЕсли;
	
	тзВыписка =  Новый ТаблицаЗначений;
	тзВыписка.Колонки.Добавить("НомерПП");
	тзВыписка.Колонки.Добавить("Приход");
	тзВыписка.Колонки.Добавить("Расход");
	тзВыписка.Колонки.Добавить("ОКПО");
	тзВыписка.Колонки.Добавить("Контрагент");
	тзВыписка.Колонки.Добавить("МФО");
	тзВыписка.Колонки.Добавить("РСчет");
	тзВыписка.Колонки.Добавить("Содержание");
	
	ФайлDBF.Первая();
	Пока НЕ ФайлDBF.ВКонце() Цикл
		// проверка на дату платежа
		Если ФайлDBF.DAT <> Параметры.ДатаДок И ФайлDBF.DAT_PR <> Параметры.ДатаДок Тогда
			ФайлDBF.Следующая();
			Продолжить;
		КонецЕсли;	
		
		// проверка на валюту
		Попытка
		Если СокрЛП(ФайлDBF.KOD_VAL) <> "980" Тогда
			ФайлDBF.Следующая();
			Продолжить;
		КонецЕсли;	
		Исключение
		КонецПопытки;
		
		// проверка на совпадение расчетного счета
		Если СокрЛП(Формат(ФайлDBF.RR_DB, "ЧГ=0")) = Параметры.РСчет Тогда  // Расход
			НовСтрока = тзВыписка.Добавить();
			НовСтрока.РСчет			= СокрЛП(Формат(ФайлDBF.RR_K,"ЧГ=0"));
			НовСтрока.МФО 			= СокрЛП(Формат(ФайлDBF.MFO_CR,"ЧГ=0"));
 			НовСтрока.ОКПО			= СокрЛП(Формат(ФайлDBF.OKPO_CR,"ЧГ=0"));
			НовСтрока.Контрагент	= СокрЛП(ФайлDBF.NAIM_K);
			НовСтрока.Приход		= 0;
            НовСтрока.Расход		= ФайлDBF.SUM;
		ИначеЕсли СокрЛП(Формат(ФайлDBF.RR_K, "ЧГ=0")) = Параметры.РСчет Тогда  // Приход
			НовСтрока = тзВыписка.Добавить();
			НовСтрока.РСчет			= СокрЛП(Формат(ФайлDBF.RR_DB,"ЧГ=0"));
			НовСтрока.МФО 			= СокрЛП(Формат(ФайлDBF.MFO_DB,"ЧГ=0"));
 			НовСтрока.ОКПО			= СокрЛП(Формат(ФайлDBF.OKPO_DB,"ЧГ=0"));
			НовСтрока.Контрагент	= СокрЛП(ФайлDBF.NAIM_D);
			НовСтрока.Приход		= ФайлDBF.SUM;
            НовСтрока.Расход		= 0;
		Иначе	
			ФайлDBF.Следующая();
			Продолжить;
		КонецЕсли;
		НовСтрока.Содержание 	= СтрЗаменить(ФайлDBF.PRIZN,Символы.ПС," ");
		НовСтрока.НомерПП	 	= СокрЛП(Формат(ФайлDBF.N_DOC,"ЧГ=0"));
		ФайлDBF.Следующая();
	КонецЦикла;	
	
	Если НЕ тзВыписка.Количество() И ФайлDBF.КоличествоЗаписей() Тогда
		Предупреждение("В текущем файле нет платежей с данной датой выписки и расчетным счетом!");
	КонецЕсли;
	
	ФайлDBF.ЗакрытьФайл();
	
	Возврат тзВыписка;
	
КонецФункции	

// Осуществляет импорт выписки из файла
//
// Параметры:
//
//	Структура Параметры   
//
// 		Ключ ДатаДок - Дата выписки  – дата 
// 		Ключ Организация - Организация - СправочникСсылка.Организации
//		Ключ РСчет - Расчетный счет организации - строка
//		Ключ ИмяФайла - Имя файла  - строка  
//		Ключ ТипФайла - Тип файла  - строка ("TXT"/"DBF"/"XML")
//
//
// Возвращаемое значение:
//
//   Таблица значений тзВыписка
//		
//		тзВыписка - Таблица платежей – таблица значений тзВыписка с полями 
//			НомерПП – строка, номер платежного поручения 
//			Приход – число, сумма прихода
//			Расход – число, сумма расхода
//			ОКПО – строка, ЕДРПОУ контрагента
//			Контрагент – строка, наименование контрагента, как оно указано в выписке
//			МФО - строка, МФО банка контрагента
//			РСчет - строка, расчетный счет контрагента
//			Содержание - строка, содержание платежа
//
//		Если при импорте выписки произошли ошибки, возвращается Неопределенно.
//      
//      При проверке на дату платежа, если платежей с датой, которая отличается от переданной было > 0
//      необходимо выдать предупреждение
//
Функция ИмпортВыписки(Параметры) Экспорт
	Если Параметры.ТипФайла = "DBF" Тогда
		Возврат ИмпортDBF(Параметры);	
	ИначеЕсли Параметры.ТипФайла = "TXT" Тогда
		Возврат ИмпортTXT(Параметры);
	ИначеЕсли Параметры.ТипФайла = "XML" Тогда
		Возврат ИмпортXML(Параметры);
	КонецЕсли;	
КонецФункции

Функция ВыровнятьВправо(Стр, Длина, Символ = " ")
	СтрокаПробелов 	= "                                                                ";
	СтрокаНулей 	= "0000000000";
	Если Символ = " " Тогда
		Строка = СтрокаПробелов;
	Иначе
		Строка = СтрокаНулей;
	КонецЕсли;	
	Стр = СокрЛП(Строка(Стр));
	ДлинаСтр = СтрДлина(Стр);
	Стр = Лев(Строка,Длина - ДлинаСтр) + Стр;
	
	Возврат Лев(Стр, Длина); // обрезаем строку, если ее длинна больше допустимой
КонецФункции

// Осуществляет экспорт платежных поручений в файл типа "TXT"
//
// Параметры:
//
//	Структура Параметры   
//                 
//		Ключ НашМФО - МФО организации - строка
//		Ключ НашСчет - 	Расчетный счет организации - строка
//      Ключ НашОКПО - 	ЕДРПОУ организации  - строка
//		Ключ ИмяФайла - Имя файла  - строка  
//		Ключ ТипФайла - Тип файла  - строка ("TXT"/"DBF"/"XML")
//		Ключ тзПлатежныеПоручения - Таблица значений с полями:
//			Номер платежного поручения (НомерПП) - строка
//			Дата платежного поручения (ДатаПП) - строка
//			Контрагент (Контрагент) - строка
//			МФО расчетного счета контрагента (МФО) - строка
//			Расчетный счет контрагента (Счет) - строка
//			ЕДРПОУ контрагента (ОКПО) - строка
//			Сумма платежного поручения (Сумма) – число 
//			Содержание платежа (Содержание) – строка 
//			!!!(Банк) - строка
//
// Возвращаемое значение:
//
//   Булево - Истина - успешный экспорт
//
Функция ЭкспортTXT(Параметры)
	// BOL формат
	Текст = Новый ТекстовыйДокумент;
	СтрокаПробелов 	= "                                                                                                                                                                                                ";
	
	Для Каждого Строка из Параметры.тзПлатежныеПоручения Цикл
		
		ТекСтрока = ВыровнятьВправо(Параметры.НашМФО, 9); //1-9
		ТекСтрока = ТекСтрока + ВыровнятьВправо(Параметры.НашСчет, 14); //10-23
		ТекСтрока = ТекСтрока + ВыровнятьВправо(Строка.МФО, 9); //24-32
		ТекСтрока = ТекСтрока + ВыровнятьВправо(Строка.Счет, 14); //33-46
		ТекСтрока = ТекСтрока + "1"; // тип операции //47-47
		ТекСтрока = ТекСтрока + ВыровнятьВправо(Формат(Строка.Сумма*100, "ЧН=0;ЧГ=0"),16); //48-63
		ТекСтрока = ТекСтрока + ВыровнятьВправо("1", 2); // Вид платежа - 1 - платежка, 6 - мемориальный ордер //64-65
		ТекСтрока = ТекСтрока + Лев(Строка.НомерПП + СтрокаПробелов, 10); //66-75
		ТекСтрока = ТекСтрока + "980"; //76-78
		ТекСтрока = ТекСтрока + Формат(Строка.ДатаПП,"ДФ=yyMMdd"); //79-84
		ТекСтрока = ТекСтрока + Лев("" + СтрокаПробелов, 6); // Дата получения документа в банке //85-90
		ТекСтрока = ТекСтрока + Лев(Параметры.НашаФирма + СтрокаПробелов, 38); //91-128
		ТекСтрока = ТекСтрока + Лев(Строка.Контрагент + СтрокаПробелов, 38); //129-166
		ТекСтрока = ТекСтрока + Лев(Строка.Содержание + СтрокаПробелов, 160); //167-326
		
		// ТекСтрока = ТекСтрока + Формат("#o"+Сп.Получить("ОКПО"), "с60"); //Дополнительные реквизиты
		
		// теперь просто пустота, ОКПО скорей всего ушло в поле 
		// № 15, "Дополнительные реквизиты". В этом поле указывается код страны 
		// плательшика/получателя если плательшик/получатель 
		// является не резидентом в следующем формате: 
		// #nП764О018#, ("П" и "О" русские заглавные символы) 
		// где "764" - код страны плательщика, "018" - код страны получателя. 
		ТекСтрока = ТекСтрока + Лев("" + СтрокаПробелов, 60); //Дополнительные реквизиты //327-386
		
		// № 16, "Код назначения платежа". 
		// Следует указывать код "070" для платежей в бюджет 
		// и оставлять поле пустым для всех прочих платежей		
		ТекСтрока = ТекСтрока + Лев(Строка.НомерПП + СтрокаПробелов, 5); //Код назначения платежа и еще что-то (поля №16-17) //387-389 //390-391
		ТекСтрока = ТекСтрока + Лев(Параметры.НашОКПО + СтрокаПробелов, 14); //392-405
		// ТекСтрока = ТекСтрока + Формат("", "с187");
		ТекСтрока = ТекСтрока + Лев(Строка.ОКПО + СтрокаПробелов, 14); //406-419
		ТекСтрока = ТекСтрока + Лев("" + СтрокаПробелов, 173); //420-428...
		
		Текст.ДобавитьСтроку(ТекСтрока);			
	
	КонецЦикла;          
	
	ИмяФайла = Параметры.ИмяФайла;	
	Попытка
		Текст.Записать(ИмяФайла, КодировкаТекста[Параметры.КодировкаФайла]);
	Исключение
		Предупреждение("Ошибка записи файла " + ИмяФайла);
		Возврат Ложь;
	КонецПопытки;		
	
	Возврат Истина;
КонецФункции

// Осуществляет экспорт платежных поручений в файл типа "XML"
//
// Параметры:
//
//	Структура Параметры   
//                 
//		Ключ НашМФО - МФО организации - строка
//		Ключ НашСчет - 	Расчетный счет организации - строка
//      Ключ НашОКПО - 	ЕДРПОУ организации  - строка
//		Ключ ИмяФайла - Имя файла  - строка  
//		Ключ ТипФайла - Тип файла  - строка ("TXT"/"DBF"/"XML")
//		Ключ тзПлатежныеПоручения - Таблица значений с полями:
//			Номер платежного поручения (НомерПП) - строка
//			Дата платежного поручения (ДатаПП) - строка
//			Контрагент (Контрагент) - строка
//			МФО расчетного счета контрагента (МФО) - строка
//			Расчетный счет контрагента (Счет) - строка
//			ЕДРПОУ контрагента (ОКПО) - строка
//			Сумма платежного поручения (Сумма) – число 
//			Содержание платежа (Содержание) – строка 
//			!!!(Банк) - строка
//
// Возвращаемое значение:
//
//   Булево - Истина - успешный экспорт
//
Функция ЭкспортXML(Параметры)
	Возврат Ложь;
КонецФункции

// Осуществляет экспорт платежных поручений в файл типа "DBF"
//
// Параметры:
//
//	Структура Параметры   
//                 
//		Ключ НашМФО - МФО организации - строка
//		Ключ НашСчет - 	Расчетный счет организации - строка
//      Ключ НашОКПО - 	ЕДРПОУ организации  - строка
//		Ключ ИмяФайла - Имя файла  - строка  
//		Ключ ТипФайла - Тип файла  - строка ("TXT"/"DBF"/"XML")
//		Ключ тзПлатежныеПоручения - Таблица значений с полями:
//			Номер платежного поручения (НомерПП) - строка
//			Дата платежного поручения (ДатаПП) - строка
//			Контрагент (Контрагент) - строка
//			МФО расчетного счета контрагента (МФО) - строка
//			Расчетный счет контрагента (Счет) - строка
//			ЕДРПОУ контрагента (ОКПО) - строка
//			Сумма платежного поручения (Сумма) – число 
//			Содержание платежа (Содержание) – строка 
//			!!!(Банк) - строка
//
// Возвращаемое значение:
//
//   Булево - Истина - успешный экспорт
//
Функция ЭкспортDBF(Параметры)
	Возврат Ложь;
КонецФункции

// Осуществляет экспорт платежных поручений в файл
//
// Параметры:
//
//	Структура Параметры   
//                 
//		Ключ НашМФО - МФО организации - строка
//		Ключ НашСчет - 	Расчетный счет организации - строка
//      Ключ НашОКПО - 	ЕДРПОУ организации  - строка
//		Ключ ИмяФайла - Имя файла  - строка  
//		Ключ ТипФайла - Тип файла  - строка ("TXT"/"DBF"/"XML")
//		Ключ тзПлатежныеПоручения - Таблица значений с полями:
//			Номер платежного поручения (НомерПП) - строка
//			Дата платежного поручения (ДатаПП) - строка
//			Контрагент (Контрагент) - строка
//			МФО расчетного счета контрагента (МФО) - строка
//			Расчетный счет контрагента (Счет) - строка
//			ЕДРПОУ контрагента (ОКПО) - строка
//			Сумма платежного поручения (Сумма) – число 
//			Содержание платежа (Содержание) – строка 
//
// Возвращаемое значение:
//
//   Булево - Истина - успешный экспорт
//
Функция ЭкспортПлатежныхПоручений(Параметры) Экспорт
	Если Параметры.ТипФайла = "DBF" Тогда
		Возврат ЭкспортDBF(Параметры);	
	ИначеЕсли Параметры.ТипФайла = "TXT" Тогда
		Возврат ЭкспортTXT(Параметры);
	ИначеЕсли Параметры.ТипФайла = "XML" Тогда
		Возврат ЭкспортXML(Параметры);
	КонецЕсли;	
		
КонецФункции

// Надо ли перекодировать текстовые поля (Контрагент, Содержание) после импорта. 
// Под перекодировкой понимается замена украинских символов
//
// Параметры: нет
//
//
// Возвращаемое значение:
//
//   Булево    – Истина - надо перекодировать/Ложь - не надо перекодировать
//
Функция ПерекодировкаИмпорта() Экспорт
	Возврат Истина;
КонецФункции

// Надо ли перекодировать текстовые поля (Контрагент, Содержание) перед экспортом. 
// Под перекодировкой понимается замена украинских символов
//
// Параметры: нет
//
// Возвращаемое значение:
//
//   Булево    – Истина - надо перекодировать/Ложь - не надо перекодировать
//
Функция ПерекодировкаЭкспорта() Экспорт
	Возврат Ложь;
КонецФункции

ИмяФормата = "Альфа";
