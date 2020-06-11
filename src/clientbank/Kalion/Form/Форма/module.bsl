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
		Если ИмяФайла = Неопределено Тогда
			Возврат "Export.txt";
		Иначе
			Возврат ИмяФайла;
		КонецЕсли;	
	Иначе	
		Если ИмяФайла = Неопределено Тогда
			Возврат "Import.txt";
		Иначе
			Возврат ИмяФайла;
		КонецЕсли;	
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
		Длг.Фильтр = "Текстовые файлы (*.*)|*.*";
		Длг.Расширение = "*";   //Параметры.ТекущийТипФайла;
	Иначе
		Длг.Фильтр = "Текстовые файлы (*.txt)|*.txt";
		Длг.Расширение = "txt";   //Параметры.ТекущийТипФайла;
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
//
// Возвращаемое значение:
//
//   Строка – текущий тип файла ("TXT"/"DBF"/"XML")
//
Функция ПолучитьТекущийТипФайла(Параметры) Экспорт
	
	ТипФайла = ВосстановитьЗначение(ИмяФормата + Параметры.Организация +  "ТипФайла" + Параметры.Режим);
	
	Если Параметры.Режим = "Импорт" Тогда
		Если ТипФайла = Неопределено Тогда
			Возврат "TXT";
		Иначе
			Возврат ТипФайла;
		КонецЕсли;	
	Иначе 
		// Параметры.Режим = "Экспорт"
		Если ТипФайла = Неопределено Тогда
			Возврат "TXT";
		Иначе
			Возврат ТипФайла;
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
	ИмпортЭкспорт.Вставить("ИмпортTXT", Истина);
	ИмпортЭкспорт.Вставить("ИмпортDBF", Ложь);
	ИмпортЭкспорт.Вставить("ИмпортXML", Ложь);
	
	ИмпортЭкспорт.Вставить("Экспорт", Истина);
	ИмпортЭкспорт.Вставить("ЭкспортTXT", Истина);
	ИмпортЭкспорт.Вставить("ЭкспортDBF", Ложь);
	ИмпортЭкспорт.Вставить("ЭкспортXML", Ложь);
	
	Возврат ИмпортЭкспорт;
	
КонецФункции

Функция РазобратьСтроку(Стр)
	СтрРазб = Стр;
	Рзд = ";";
	Сп = Новый СписокЗначений;
	Если Сред(СтрРазб, 1, 1) = Рзд Тогда
		СтрРазб = Сред(СтрРазб, 2);    
	КонецЕсли;             
	Инд = Найти(СтрРазб, Рзд);
	Пока Инд <> 0 Цикл
		ТекСтр = Сред(СтрРазб, 1, Инд - 1);
		//Сп.Добавить(СокрЛП(ТекСтр));
		Сп.Добавить(ТекСтр);
		СтрРазб = Сред(СтрРазб, Инд + 1);
		Инд = Найти(СтрРазб, Рзд);
	КонецЦикла;
	Возврат Сп;
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
	ФайлTXT	= Новый ТекстовыйДокумент;
	ИмяФайла = Параметры.ИмяФайла;
	Попытка
		ФайлTXT.Прочитать(ИмяФайла, КодировкаТекста[Параметры.КодировкаФайла]);
	Исключение
		Предупреждение("Ошибка открытия файла " + ИмяФайла);
		Возврат Неопределено;
	КонецПопытки;		
	
	тзВыписка =  Новый ТаблицаЗначений;
	тзВыписка.Колонки.Добавить("НомерПП");
	тзВыписка.Колонки.Добавить("Приход");
	тзВыписка.Колонки.Добавить("Расход");
	тзВыписка.Колонки.Добавить("ОКПО");
	тзВыписка.Колонки.Добавить("Контрагент");
	тзВыписка.Колонки.Добавить("МФО");
	тзВыписка.Колонки.Добавить("РСчет");
	тзВыписка.Колонки.Добавить("Содержание");
	
	Дельта = -1;
	Для н = 2 По ФайлTXT.КоличествоСтрок() Цикл
		ТекСтрока = ФайлTXT.ПолучитьСтроку(н);
		
		Спис = Новый СписокЗначений;
		Спис = РазобратьСтроку(ТекСтрока);
		
		//Если   (СокрЛП(Спис[5+Дельта].Значение)="IPLL00") 
		//	ИЛИ ((СокрЛП(Спис[5+Дельта].Значение)="CLLL00") И (СокрЛП(Спис[11+Дельта].Значение)="C")) Тогда
				
		//индекс в 7ке начинается с 1, в 8ке с 0... нужно все уменьшить на 1
		РСчет = СокрЛП(Спис[1+Дельта].Значение);
		
		Если РСчет <> Формат(Параметры.РСчет,"ЧН=0") Тогда
			Продолжить;    
		КонецЕсли;
		
		Валютность = СокрЛП(Спис[9+Дельта].Значение);//UAH
		ДатаОперации = Лев(Спис[2+Дельта].Значение,8);  // в таком виде: 14.09.2006 11:35
		
		Если ДатаОперации <> Формат(Параметры.ДатаДок,"ДФ=yyyyMMdd") Тогда
			Продолжить;    
		КонецЕсли;
		
		МФОКонтрагента = СокрЛП(Спис[33+Дельта].Значение);
		КодОКПОКонтрагента = СокрЛП(Спис[34+Дельта].Значение);
		РСчетКонтрагента = СокрЛП(Спис[26+Дельта].Значение);
		ИмяКонтрагента = СокрЛП(Спис[27+Дельта].Значение);
		
		Если Лев(ИмяКонтрагента, 1)  = """" И Прав(ИмяКонтрагента, 1)  = """" Тогда
			ИмяКонтрагента = Сред(ИмяКонтрагента, 2, СтрДлина(ИмяКонтрагента) - 2);
			ИмяКонтрагента = СтрЗаменить(ИмяКонтрагента,"""""", """");
		КонецЕсли;
		
		НомерПП  = СокрЛП(Спис[25+Дельта].Значение);
		
		Сумма  = СокрЛП(Спис[10+Дельта].Значение)*0.01;
		ДебетКредит  = СокрЛП(Спис[11+Дельта].Значение);
		Если ДебетКредит = "D" Тогда
			Дебет = 0;
			Кредит = Сумма;	
		Иначе 	
			Дебет = Сумма;
			Кредит = 0;				
		КонецЕсли; 
		
		//Если ПустаяСтрока(Кредит) Тогда
		//	Кредит = 0;
		//Иначе
		//	Кредит = Число(Кредит);
		//КонецЕсли;	
		//
		//Дебет  = СокрЛП(Спис[15+Дельта].Значение);
		//Если ПустаяСтрока(Дебет) Тогда
		//	Дебет = 0;
		//Иначе
		//	Дебет = Число(Дебет);
		//КонецЕсли;	
		
		Назначение = Спис[24+Дельта].Значение;
		
		//// если в содержании есть символ ";" - точка с запятой
		//Для Инд = 17 По Спис.Количество() - 1 Цикл
		//	Назначение = Назначение + ";" + Спис[Инд+Дельта].Значение;
		//КонецЦикла;	
		
		Назначение = СокрЛП(Назначение);
		
		Если Лев(Назначение, 1)  = """" И Прав(Назначение, 1)  = """" Тогда
			Назначение = Сред(Назначение, 2, СтрДлина(Назначение) - 2);
			//Назначение = СтрЗаменить(Назначение,"""""", """");
		КонецЕсли;
		Если   (СокрЛП(Спис[5+Дельта].Значение)="IPLL00")  
			ИЛИ ((СокрЛП(Спис[5+Дельта].Значение)="CLLL00")или (СокрЛП(Спис[5+Дельта].Значение)="ACLL00") И (СокрЛП(Спис[11+Дельта].Значение)="C")) Тогда
			
			
			
			НовСтрока = тзВыписка.Добавить();
		Если (Кредит > 0) Тогда //Расход
			НовСтрока.НомерПП		= НомерПП;
			НовСтрока.Контрагент	= ИмяКонтрагента;
			НовСтрока.ОКПО			= СокрЛП(Формат(КодОКПОКонтрагента,"ЧГ=0"));
			НовСтрока.РСчет			= СокрЛП(Формат(РСчетКонтрагента,"ЧГ=0"));
			НовСтрока.МФО 			= СокрЛП(Формат(МФОКонтрагента,"ЧГ=0"));
			
			НовСтрока.Расход 		= Кредит;
			НовСтрока.Приход		= 0;
			
		Иначе //Приход
			НовСтрока.НомерПП		= НомерПП;
			НовСтрока.Контрагент	= ИмяКонтрагента;
			НовСтрока.ОКПО			= СокрЛП(Формат(КодОКПОКонтрагента,"ЧГ=0"));
			НовСтрока.РСчет			= СокрЛП(Формат(РСчетКонтрагента,"ЧГ=0"));
			НовСтрока.МФО 			= СокрЛП(Формат(МФОКонтрагента,"ЧГ=0"));
			
			НовСтрока.Расход 		= 0;
			НовСтрока.Приход		= Дебет;
			
		КонецЕсли;
		НовСтрока.Содержание 	= Назначение;
		КонецЕсли;

	КонецЦикла;	
	
	Если НЕ тзВыписка.Количество() И ФайлTXT.КоличествоСтрок() Тогда
		Предупреждение("В текущем файле нет платежей с данной датой выписки и расчетным счетом!");
	КонецЕсли;
	
	Возврат тзВыписка;	
	
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
	Возврат Неопределено;	
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
	Текст 				= Новый ТекстовыйДокумент;
	
	ИмяФайла = Параметры.ИмяФайла;
	
	Рзд = "|";
	Инд = 0;
	Для Каждого Строка из Параметры.тзПлатежныеПоручения Цикл
		Инд = Инд + 1;
		ТекСтрока = "" + Инд + Рзд;	
		
		ТекСтрока = ТекСтрока + Рзд + Формат(СокрЛП(Параметры.НашМФО),"ЧГ=0") + Рзд;
		ТекСтрока = ТекСтрока + Формат(СокрЛП(Параметры.НашСчет),"ЧГ=0") + Рзд;
		ТекСтрока = ТекСтрока + Формат(СокрЛП(Параметры.НашОКПО),"ЧГ=0") + Рзд;
		ТекСтрока = ТекСтрока + Формат(СокрЛП(Строка.МФО),"ЧГ=0") + Рзд;
		ТекСтрока = ТекСтрока + Формат(СокрЛП(Строка.Счет),"ЧГ=0") + Рзд;
		ТекСтрока = ТекСтрока + Формат(СокрЛП(Строка.ОКПО),"ЧГ=0") + Рзд;
		ТекСтрока = ТекСтрока + Формат(Строка.ДатаПП,"ДФ=dd.MM.yyyy") + Рзд;
		ТекСтрока = ТекСтрока + СокрЛП(Строка.НомерПП) + Рзд;
		ТекСтрока = ТекСтрока + СокрЛП(Параметры.НашаФирма) + Рзд;
		ТекСтрока = ТекСтрока + Строка.Контрагент + Рзд;
		ТекСтрока = ТекСтрока + СокрЛ(Формат(Строка.Сумма, "ЧРД=.;ЧН=0;ЧГ=0;ЧЦ=15;ЧДЦ=2")) + Рзд + Рзд + Рзд; //дата и время проведения банком (должны быть пустыми)
		ТекСтрока = ТекСтрока + Лев(СокрЛП(Строка.Содержание),120) + Рзд;
		Если Строка.СуммаНДС = 0 Тогда
			ТекСтрока = ТекСтрока + "Без ПДВ" + Рзд + Рзд + Рзд; 
		Иначе
			ТекСтрока = ТекСтрока + "разом з ПДВ " + Формат(Строка.СуммаНДС,"ЧРД=.; ЧН=0; ЧГ=0; ЧЦ=15; ЧДЦ=2") + Рзд + Рзд + Рзд; 
		КонецЕсли;	
		
		Текст.ДобавитьСтроку(ТекСтрока);
	
	КонецЦикла;          
	
	ИмяФайла = Параметры.ИмяФайла;	
	Попытка
		Текст.Записать(ИмяФайла, КодировкаТекста.ANSI);
	Исключение
		Предупреждение("Ошибка записи файлов ");
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
	Возврат Ложь;
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

ИмяФормата = "Калион";
