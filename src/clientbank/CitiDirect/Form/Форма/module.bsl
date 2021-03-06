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
//		Ключ РСчет - Расчетный счет
// 
// Возвращаемое значение:
//
//   имя файла по умолчанию
//
Функция СформироватьИмяФайла(Параметры) Экспорт 
	ИмяФайла = ВосстановитьЗначение(ИмяФормата + Параметры.Организация +  "ИмяФайла" + Параметры.Режим);
	Если Параметры.Режим = "Импорт" Тогда
		
		//Месяц = Месяц(Параметры.Дата);
		//Месяц = ?(Месяц = 10,"A",?(Месяц = 11,"B",?(Месяц = 12,"C",Месяц)));
		//сФайл = "SP" + Лев(СокрЛП(Параметры.КодВБанке),3) + Прав(СокрЛП(Параметры.РСчет),3) + "." + Месяц + Прав(День(Параметры.Дата),2);
		
		Если ИмяФайла = Неопределено Тогда
			Возврат "Export.txt";
		Иначе
			Возврат ИмяФайла;
		КонецЕсли;	
	Иначе	
		// здесь Параметры.Дата = ДатаППС
		Месяц = Месяц(Параметры.Дата);
		Месяц = ?(Месяц = 10,"A",?(Месяц = 11,"B",?(Месяц = 12,"C",Месяц)));
		//сФайл = Прав(СокрЛП(Параметры.НашСчет),3) + "_" + Месяц + Прав(День(Параметры.Дата),2) + ".imp";
		сФайл = Прав(СокрЛП(Параметры.РСчет),3) + "_" + Месяц + Прав(День(Параметры.Дата),2) + ".imp";
		
		Каталог = ПолучитьКаталог(ИмяФайла);
		Возврат Каталог + сФайл;
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
	Длг.Фильтр = "Все файлы (*.*)|*.*";
	Длг.Расширение = "*";   //Параметры.ТекущийТипФайла;
	
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

// Специально для СитиБанка
Функция РазобратьСтроку(Стр)
	СтрРазб = Стр;
	Рзд = "@";
	Сп = Новый СписокЗначений;
	Если Сред(СтрРазб, 1, 1) = Рзд Тогда
		СтрРазб = Сред(СтрРазб, 2);    
	КонецЕсли;             
	Инд = Найти(СтрРазб, Рзд);
	Пока Инд <> 0 Цикл
		ТекСтр = Сред(СтрРазб, 1, Инд - 1);
		Сп.Добавить(СокрЛП(ТекСтр));
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
		ФайлTXT.Прочитать(ИмяФайла, КодировкаТекста.ANSI); //Windows
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
	
	Для н = 1 По ФайлTXT.КоличествоСтрок() Цикл
		ТекСтрока = ФайлTXT.ПолучитьСтроку(н);
		
		Спис = Новый СписокЗначений;
		Спис = РазобратьСтроку(ТекСтрока);      
		
		//индекс в 7ке начинается с 1, в 8ке с 0... нужно все уменьшить на 1
		ТипДок = СокрЛП(Спис[31].Значение);
		Если ТипДок <> "TRF" Тогда
			Продолжить;    
		КонецЕсли;
		
		
		РСчет = СокрЛП(Спис[1].Значение);
		ДатаОперации = СокрЛП(Спис[30].Значение);  // в таком виде: 29/03/2004
		
		Если ДатаОперации <> Формат(Параметры.ДатаДок,"ДФ=dd/MM/yyyy") Тогда
			Продолжить;    
		КонецЕсли;
		
		Если РСчет <> Формат(Параметры.РСчет,"ЧН=0") Тогда
			Продолжить;    
		КонецЕсли;
		
		Назначение = СокрЛП(Спис[38].Значение);
		
		Валютность = СокрЛП(Спис[26].Значение);//UAH
		ДК  = СокрЛП(Спис[25].Значение);
		Сумма = Макс(Число(СокрЛП(Спис[45].Значение)),-Число(СокрЛП(Спис[45].Значение)));//Сумма 
		
		
        ИмяКонтрагента = СокрЛП(Спис[11].Значение); 
		МФОКонтрагента = СокрЛП(Спис[10].Значение);
		КодОКПОКонтрагента = СокрЛП(Спис[9].Значение);
		РСчетКонтрагента = СокрЛП(Спис[7].Значение); //8, 9, 13

		НомерПП  = СокрЛП(Спис[48].Значение);
			
		//Сум = Число(Сумма-СуммаКомиссибанка);
		//Сум = Число(Сумма);
		
		НовСтрока = тзВыписка.Добавить();
		Если (ДК <> "C") Тогда //Расход
			НовСтрока.НомерПП		= НомерПП;
			НовСтрока.Контрагент	= ИмяКонтрагента;
			НовСтрока.ОКПО			= СокрЛП(Формат(КодОКПОКонтрагента,"ЧГ=0"));
			НовСтрока.РСчет			= СокрЛП(Формат(РСчетКонтрагента,"ЧГ=0"));
			НовСтрока.МФО 			= СокрЛП(Формат(МФОКонтрагента,"ЧГ=0"));
			
			НовСтрока.Расход 		= Сумма;
			НовСтрока.Приход		= 0;
			
		Иначе //Приход
			НовСтрока.НомерПП		= НомерПП;
			НовСтрока.Контрагент	= ИмяКонтрагента;
			НовСтрока.ОКПО			= СокрЛП(Формат(КодОКПОКонтрагента,"ЧГ=0"));
			НовСтрока.РСчет			= СокрЛП(Формат(РСчетКонтрагента,"ЧГ=0"));
			НовСтрока.МФО 			= СокрЛП(Формат(МФОКонтрагента,"ЧГ=0"));
			
			НовСтрока.Расход 		= 0;
			НовСтрока.Приход		= Сумма;
			
		КонецЕсли;
		НовСтрока.Содержание 	= Назначение;
		
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

// Специально для СитиБанка
Процедура Разделить4(СтрВх,Стр1,Стр2,Стр3,Стр4,Кво) 
	СтрВх	= СтрЗаменить(СтрВх,Символы.ПС,"");
	СтрВх	= СтрЗаменить(СтрВх,"""","");
	СтрВх	= СтрЗаменить(СтрВх,"№","N");
	Стр1 	= Лев(СтрВх,Кво);
	СтрВх 	= Прав(СтрВх,СтрДлина(СтрВх) - Кво);
	Стр2 	= Лев(СтрВх,Кво);
	СтрВх 	= Прав(СтрВх,СтрДлина(СтрВх) - Кво);
	Стр3 	= Лев(СтрВх,Кво);
	СтрВх 	= Прав(СтрВх,СтрДлина(СтрВх) - Кво);
	Стр4 	= Лев(СтрВх,Кво);
	СтрВх 	= Прав(СтрВх,СтрДлина(СтрВх) - Кво);
КонецПроцедуры  

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
	Перем Стр1,Стр2,Стр3,Стр4;
	Текст = Новый ТекстовыйДокумент;
	Рзд = "·";
	//Счетчик = 1;
	
	Для Каждого Строка из Параметры.тзПлатежныеПоручения Цикл
	
	//	Если СтрДлина(СокрЛП(Сп.Получить("Содержание"))) < 3 Тогда
	//		Сообщить("________________________________________________________________________________");
	//		Сообщить("В документе" + Сп.Получить("НомерПП") + " содержание платежа меньше 10 символов!");
	//		Возврат 0;
	//	КонецЕсли;   
		
		Текст.ДобавитьСтроку("0");
		Текст.ДобавитьСтроку("001");
		Текст.ДобавитьСтроку("1");
		Текст.ДобавитьСтроку(СтрЗаменить(СокрЛП(Формат(Строка.Сумма,"ЧЦ=13; ЧДЦ=2;ЧГ=0")),",","."));
		//Текст.ДобавитьСтроку(СтрЗаменить(Число(Строка.Сумма),",","."));
		Текст.ДобавитьСтроку("2");
		Текст.ДобавитьСтроку(СокрЛП(Строка.НомерПП));
		Текст.ДобавитьСтроку("3");
	//	Если СокрЛП(Сп.Получить("НашСчет"))="" Тогда
	//		Сообщить("________________________________________________________________________________");
	//		Сообщить("Не указан наш счет в Сити-Банке");
	//		Возврат 0;
	//	КонецЕсли;
		//Текст.ДобавитьСтроку("0" + Прав(СокрЛП(Параметры.НашСчет),9));
		Текст.ДобавитьСтроку(Прав(СокрЛП(Параметры.НашСчет),9));
		Текст.ДобавитьСтроку("4");
		Текст.ДобавитьСтроку("UKKIEV12");
		Текст.ДобавитьСтроку("5");
	//	Если СокрЛП(Строка(Сп.Получить("МФО")))="" Тогда
	//		Сообщить("________________________________________________________________________________");
	//		Сообщить("Не указан МФО контрагента");
	//		Возврат 0;
	//	КонецЕсли;
		Текст.ДобавитьСтроку(СокрЛП(Строка.МФО));
		Текст.ДобавитьСтроку("6");
		Текст.ДобавитьСтроку((СокрЛП(Лев(Строка.Контрагент,35))));
		Текст.ДобавитьСтроку("7");
		Текст.ДобавитьСтроку("");
		Текст.ДобавитьСтроку("");
		Текст.ДобавитьСтроку("8");
	//	Если СокрЛП(Строка(Сп.Получить("Счет"))) = "" Тогда
	//		Сообщить("________________________________________________________________________________");
	//		Сообщить("Не указан р/с контрагента");
	//		Возврат 0;
	//	КонецЕсли;
		Текст.ДобавитьСтроку(СокрЛП(Строка.Счет));
		Текст.ДобавитьСтроку("9");
	//	Если СокрЛП(Строка(Сп.Получить("ОКПО"))) = "" Тогда
	//		Сообщить("________________________________________________________________________________");
	//		Сообщить("Не указан код ЕГРПОУ контрагента");
	//		Возврат 0;
	//	КонецЕсли;
		Текст.ДобавитьСтроку(Строка.ОКПО);
		Текст.ДобавитьСтроку("10");
		Разделить4(Строка.Содержание,Стр1,Стр2,Стр3,Стр4,35);
	//	Если СтрДлина(СокрЛП(Строка(Стр1))) < 10 Тогда
	//		Сообщить("________________________________________________________________________________");
	//		Сообщить("Длина назначения платежа меньше 10-ти символов");
	//		Возврат 0;
	//	КонецЕсли;
		Текст.ДобавитьСтроку(Стр1);
		Текст.ДобавитьСтроку(Стр2);
		Текст.ДобавитьСтроку(Стр3);
		Текст.ДобавитьСтроку(Стр4);
		Текст.ДобавитьСтроку("11");
		Текст.ДобавитьСтроку("N");
		Текст.ДобавитьСтроку("12");
		Текст.ДобавитьСтроку("");
		Текст.ДобавитьСтроку("13");
		Текст.ДобавитьСтроку("");
		Текст.ДобавитьСтроку("14");
		Текст.ДобавитьСтроку("");
		Текст.ДобавитьСтроку("15");
		Текст.ДобавитьСтроку(?(Число(Строка.СуммаНДС) > 0,"Y","N"));
		Текст.ДобавитьСтроку("16");
		//Текст.ДобавитьСтроку(СокрЛП(Формат(Строка.СуммаНДС,"ЧЦ=13; ЧДЦ=2")));
		Текст.ДобавитьСтроку(СтрЗаменить(СокрЛП(Формат(Строка.СуммаНДС,"ЧЦ=13; ЧДЦ=2;ЧГ=0")),",","."));
		Текст.ДобавитьСтроку("-1");
	
	КонецЦикла;          
	
	ИмяФайла = Параметры.ИмяФайла;	
	Попытка
		Текст.Записать(ИмяФайла, КодировкаТекста.ANSI);
	Исключение
		Предупреждение("Ошибка записи файла " + ИмяФайла);
		Возврат Ложь;
	КонецПопытки;		
	
	Возврат Ложь;
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

ИмяФормата = "СитиБанк (через CitiDirect)";
