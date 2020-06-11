﻿Перем ИмяФормата;

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
	ИмяФайла = ПолучитьСохраненнуюНастройку("ИмяФайла", Параметры);
	Если Параметры.Режим = "Импорт" Тогда
		Если НЕ ЗначениеЗаполнено(ИмяФайла) Тогда
			Возврат "Import.dbf";
		Иначе
			Возврат ИмяФайла;
		КонецЕсли;	
	Иначе	
		Если НЕ ЗначениеЗаполнено(ИмяФайла) Тогда
			Возврат "Export.dbf";
		Иначе
			Возврат ИмяФайла;
		КонецЕсли;	
	КонецЕсли;	
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
	
	ТипФайла = ПолучитьСохраненнуюНастройку("ТипФайла", Параметры);
	
	Если Параметры.Режим = "Импорт" Тогда
		Если НЕ ЗначениеЗаполнено(ТипФайла) Тогда
			Возврат "DBF";
		Иначе
			Возврат ТипФайла;
		КонецЕсли;	
	Иначе 
		// Параметры.Режим = "Экспорт"
		Если НЕ ЗначениеЗаполнено(ТипФайла) Тогда
			Возврат "DBF";
		Иначе
			Возврат ТипФайла;
		КонецЕсли;	
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
	
	КодировкаФайла = ПолучитьСохраненнуюНастройку("КодировкаФайла", Параметры);
	
	Если Параметры.Режим = "Импорт" Тогда
		Если НЕ ЗначениеЗаполнено(КодировкаФайла) Тогда
			Возврат "ANSI"; // ANSI (Windows) или OEM (DOS)
		Иначе
			Возврат КодировкаФайла;
		КонецЕсли;	
	Иначе 
		// Параметры.Режим = "Экспорт"
		Если НЕ ЗначениеЗаполнено(КодировкаФайла) Тогда
			Возврат "ANSI"; // ANSI (Windows) или OEM (DOS)
		Иначе
			Возврат КодировкаФайла;
		КонецЕсли;	
	КонецЕсли;	

КонецФункции

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
	ИмпортЭкспорт.Вставить("ЭкспортTXT", Ложь);
	ИмпортЭкспорт.Вставить("ЭкспортDBF", Истина);
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
	//ФайлDBF.Кодировка = КодировкаXBase[Параметры.КодировкаФайла];
	ФайлDBF.Кодировка = КодировкаXBase.ANSI;
	
	ИмяФайла = Параметры.ИмяФайла;
	
	Попытка
		ФайлDBF.ОткрытьФайл(ИмяФайла,,Истина); //Только для чтения
	Исключение
		Возврат "Ошибка открытия файла " + ИмяФайла;
	КонецПопытки;		
	
	Если НЕ ФайлDBF.Открыта() Тогда
		Возврат "Ошибка открытия файла " + ИмяФайла;
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
		
		Если ФайлDBF.ЗаписьУдалена() Тогда
			ФайлDBF.Следующая();
			Продолжить;
		КонецЕсли;		
		
		// проверка на совпадение расчетного счета
		Если  ФайлDBF.DATA_S<> Параметры.ДатаДок И СокрЛП(ФайлDBF.DATA_S) <> Формат(Параметры.ДатаДок,"ДФ=yyyyMMdd") Тогда
			ФайлDBF.Следующая();
			Продолжить;
		КонецЕсли;	
		
		// проверка на совпадение расчетного счета
		Если Число(ФайлDBF.DK) = 1 Тогда        //расход
			НовСтрока = тзВыписка.Добавить();
			НовСтрока.РСчет			= СокрЛП(Формат(ФайлDBF.KL_CHK_K,"ЧГ=0"));
			НовСтрока.МФО 			= СокрЛП(Формат(ФайлDBF.MFO_K,"ЧГ=0"));
 			НовСтрока.ОКПО			= СокрЛП(Формат(ФайлDBF.KL_OKP_K,"ЧГ=0"));
			НовСтрока.Контрагент	= СокрЛП(ФайлDBF.KL_NM_K);
			НовСтрока.Приход		= 0;
            НовСтрока.Расход		= ФайлDBF.S;
		ИначеЕсли Число(ФайлDBF.DK) = 2 Тогда   //приход
			НовСтрока = тзВыписка.Добавить();
			НовСтрока.РСчет			= СокрЛП(Формат(ФайлDBF.KL_CHK_K,"ЧГ=0"));
			НовСтрока.МФО 			= СокрЛП(Формат(ФайлDBF.MFO_K,"ЧГ=0"));
 			НовСтрока.ОКПО			= СокрЛП(Формат(ФайлDBF.KL_OKP_K,"ЧГ=0"));
			НовСтрока.Контрагент	= СокрЛП(ФайлDBF.KL_NM_K);  
			НовСтрока.Приход		= ФайлDBF.S;
            НовСтрока.Расход		= 0;
		Иначе	
			ФайлDBF.Следующая();
			Продолжить;
		КонецЕсли;
		
		НовСтрока.НомерПП 			= ФайлDBF.ND;
		НовСтрока.Содержание 		= СтрЗаменить(ФайлDBF.N_P,Символы.ПС," ");
		
		ФайлDBF.Следующая();
	КонецЦикла;	
	
	Если НЕ тзВыписка.Количество() И ФайлDBF.КоличествоЗаписей() Тогда
		Возврат "В текущем файле нет платежей с данной датой выписки и расчетным счетом!";
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
	
	ФайлDBF = Новый XBase;
	ФайлDBF.Кодировка = КодировкаXBase[Параметры.КодировкаФайла];
	
	ФайлDBF.Поля.Добавить("TIP_DOC","C",1,);
	ФайлDBF.Поля.Добавить("N_DOC","C",10,);
	ФайлDBF.Поля.Добавить("DATE_DOC","D",8,0);
	ФайлDBF.Поля.Добавить("SUM_DOC","N",17,2);
	ФайлDBF.Поля.Добавить("ACCOUNT_A","C",16,0);
	ФайлDBF.Поля.Добавить("NAME_A","C",40,0);
	ФайлDBF.Поля.Добавить("OKPO1_A","C",10,0);
	ФайлDBF.Поля.Добавить("MFO_A","N",9,0);
	ФайлDBF.Поля.Добавить("BANK_A","C",45,0);
	ФайлDBF.Поля.Добавить("ACCOUNT_B","C",16,0);
	ФайлDBF.Поля.Добавить("NAME_B","C",40,0);
	ФайлDBF.Поля.Добавить("OKPO2_B","C",10,0);
	ФайлDBF.Поля.Добавить("MFO_B","N",9,0);
	ФайлDBF.Поля.Добавить("BANK_B","C",45,0);
	ФайлDBF.Поля.Добавить("N_P","C",160,0);
	ФайлDBF.Поля.Добавить("PACKET","C",1,0);
	
	// === старые поля для совместимости старых версий ПО ===
	ФайлDBF.Поля.Добавить("TIP","N",1,0);
	ФайлDBF.Поля.Добавить("N_D","N",10,0);
	ФайлDBF.Поля.Добавить("DATE","C",10,);
	ФайлDBF.Поля.Добавить("SUMMA","N",15,2);

//	ФайлDBF.Поля.Добавить("NAME_A","C",40,);
	ФайлDBF.Поля.Добавить("COUNT_A","N",16,0);
//	ФайлDBF.Поля.Добавить("MFO_A","N",9,0);
	ФайлDBF.Поля.Добавить("KSCH_A","N",16,0);
//	ФайлDBF.Поля.Добавить("BANK_A","C",45,);
//	ФайлDBF.Поля.Добавить("NAME_B","C",40,);
	ФайлDBF.Поля.Добавить("COUNT_B","N",16,0);
//	ФайлDBF.Поля.Добавить("MFO_B","N",9,0);
	ФайлDBF.Поля.Добавить("KSCH_B","N",16,0);
//	ФайлDBF.Поля.Добавить("BANK_B","C",45,);

//	ФайлDBF.Поля.Добавить("N_P","C",160,);
	ФайлDBF.Поля.Добавить("VAL","C",4,);
//	ФайлDBF.Поля.Добавить("PACKET","C",1,);
	ФайлDBF.Поля.Добавить("USER","C",20,);
	ФайлDBF.Поля.Добавить("K_S","C",6,);
	ФайлDBF.Поля.Добавить("OKPO_A","C",10,0);
	ФайлDBF.Поля.Добавить("OKPO_B","C",10,0);
	ФайлDBF.Поля.Добавить("SKP","C",2,);
	ФайлDBF.Поля.Добавить("SOURCE","C",12,);
	ФайлDBF.Поля.Добавить("OI","C",3,);
	
	Попытка
		ФайлDBF.СоздатьФайл(Параметры.ИмяФайла);
	Исключение
		Возврат "Ошибка создания файла " + Параметры.ИмяФайла;
	КонецПопытки;		
	
	Для Каждого Строка из Параметры.тзПлатежныеПоручения Цикл
		ФайлDBF.Добавить();
		
		ФайлDBF.TIP_DOC = "p";
		ФайлDBF.ACCOUNT_A 	= Параметры.НашСчет;
		ФайлDBF.MFO_A	 	= Параметры.НашМФО;
		ФайлDBF.OKPO1_A 	= Параметры.НашОКПО;
		ФайлDBF.NAME_A	 	= Параметры.НашаФирма;
		ФайлDBF.BANK_A	 	= Параметры.НашБанк;
		ФайлDBF.MFO_B 		= Строка.МФО;
		ФайлDBF.ACCOUNT_B	= Строка.Счет;
		ФайлDBF.OKPO2_B		= Строка.ОКПО;
		ФайлDBF.NAME_B		= Строка.Контрагент;
		ФайлDBF.SUM_DOC		= Строка.Сумма;
		ФайлDBF.N_DOC		= Строка.НомерПП;
		ФайлDBF.DATE_DOC	= Строка.ДатаПП;
		ФайлDBF.BANK_B		= Строка.Банк;
		ФайлDBF.N_P			= Строка.Содержание;
		
		// === старые поля для совместимости старых версий ПО ===
//		ФайлDBF.NAME_A 	= Параметры.НашаФирма;
		ФайлDBF.COUNT_A	= Параметры.НашСчет;
//		ФайлDBF.MFO_A 	= Параметры.НашМФО;
		ФайлDBF.OKPO_A 	= Параметры.НашОКПО;
		ФайлDBF.BANK_A 	= Параметры.НашБанк;
		
//		ФайлDBF.MFO_B 	= Строка.МФО;
		ФайлDBF.COUNT_B	= Строка.Счет;
		ФайлDBF.OKPO_B	= Строка.ОКПО;
//		ФайлDBF.NAME_B	= Строка.Контрагент;
		ФайлDBF.SUMMA	= Строка.Сумма;
//		ФайлDBF.DATE	= Формат(Строка.ДатаПП,"ДФ=dd.MM.yyyy"); 
		ФайлDBF.DATE	= Формат(Строка.ДатаПП,"ДФ=yyyyMMdd");
		ФайлDBF.BANK_B	= Строка.Банк;
		
		ФайлDBF.N_D		= Строка.НомерПП;
//		ФайлDBF.N_P		= Строка.Содержание;
		
		ФайлDBF.TIP 	= 1;
		ФайлDBF.VAL 	= "980";
		
		ФайлDBF.Записать();
	КонецЦикла;
	ФайлDBF.ЗакрытьФайл();
	
	Возврат Истина;
	
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
Функция СформироватьФильтрВыбораФайла(Параметры) Экспорт 
	Если Параметры.ТипФайла = "TXT" Тогда
		Возврат НСтр("ru = 'Текстовые файлы (*.dat)|*.dat|Текстовые файлы (*.txt)|*.txt'");
	ИначеЕсли Параметры.ТипФайла = "DBF" Тогда
		Возврат НСтр("ru='Файлы dBase (*.dbf)|*.dbf'");
	ИначеЕсли Параметры.ТипФайла = "XML" Тогда
		Возврат НСтр("ru='XML файлы (*.xml)|*.xml'");
	Иначе	
		Возврат НСтр("ru='Все файлы (*.*)|*.*'");
	КонецЕсли;	
КонецФункции

Функция ПолучитьСохраненнуюНастройку(ИмяНастройки, Параметры) Экспорт
	
	Если ИмяНастройки = "КодировкаФайла" Тогда
		
		ИмяКлючаНастроек = ИмяФормата + Параметры.Организация + Параметры.Режим;
		Настройки = ХранилищеСистемныхНастроек.Загрузить("ВнешняяОбработка.КлиентБанк2/ОбработкаФормата", "КлиентБанк2" + ИмяКлючаНастроек);
	
		Если Настройки <> Неопределено Тогда
			Возврат Настройки.Получить(ИмяНастройки + ИмяКлючаНастроек);
		КонецЕсли;	
		
	ИначеЕсли ИмяНастройки = "ТипФайла" Тогда
		
		ИмяКлючаНастроек = ИмяФормата + Параметры.Организация + Параметры.Режим;
		Настройки = ХранилищеСистемныхНастроек.Загрузить("ВнешняяОбработка.КлиентБанк2/ОбработкаФормата", "КлиентБанк2" + ИмяКлючаНастроек);
	
		Если Настройки <> Неопределено Тогда
			Возврат Настройки.Получить(ИмяНастройки + ИмяКлючаНастроек);
		КонецЕсли;	
		
	ИначеЕсли ИмяНастройки = "КодВБанке" Тогда
		
		ИмяКлючаНастроек = ИмяФормата + Параметры.Организация + Параметры.Режим;
		Настройки = ХранилищеСистемныхНастроек.Загрузить("ВнешняяОбработка.КлиентБанк2/ОбработкаФормата", "КлиентБанк2" + ИмяКлючаНастроек);
	
		Если Настройки <> Неопределено Тогда
			Возврат Настройки.Получить(ИмяНастройки + ИмяКлючаНастроек);
		КонецЕсли;	
		
	ИначеЕсли ИмяНастройки = "ИмяФайла" Тогда
		
		ИмяКлючаНастроек = ИмяФормата + Параметры.Организация + Параметры.Режим + Параметры.ТипФайла;
		Настройки = ХранилищеСистемныхНастроек.Загрузить("ВнешняяОбработка.КлиентБанк2/ОбработкаФормата", "КлиентБанк2" + ИмяКлючаНастроек);
	
		Если Настройки <> Неопределено Тогда
			Возврат Настройки.Получить(ИмяНастройки + ИмяКлючаНастроек);
		КонецЕсли;	
		
	КонецЕсли;
	
	Возврат "";
КонецФункции

// Сохраняет настройки 
Процедура СохранитьНастройки(Параметры) Экспорт
	
	Настройки = Новый Соответствие;
	ИмяКлючаНастроек = ИмяФормата + Параметры.Организация + Параметры.Режим;
	Настройки.Вставить("ТипФайла" 		+ ИмяКлючаНастроек, Параметры.ТекущийТипФайла);
	Настройки.Вставить("КодировкаФайла" + ИмяКлючаНастроек, Параметры.КодировкаФайла);
	Настройки.Вставить("КодВБанке" 		+ ИмяКлючаНастроек, Параметры.КодВБанке);
	ХранилищеСистемныхНастроек.Сохранить("ВнешняяОбработка.КлиентБанк2/ОбработкаФормата", "КлиентБанк2" + ИмяКлючаНастроек, Настройки);
	
	Настройки = Новый Соответствие;
	ИмяКлючаНастроек = ИмяФормата + Параметры.Организация + Параметры.Режим + Параметры.ТекущийТипФайла;
	Настройки.Вставить("ИмяФайла" 		+ ИмяКлючаНастроек, Параметры.ТекущееИмяФайла);
	ХранилищеСистемныхНастроек.Сохранить("ВнешняяОбработка.КлиентБанк2/ОбработкаФормата", "КлиентБанк2" + ИмяКлючаНастроек, Настройки);
	
КонецПроцедуры // СохранитьНастройкиФормы()

//ИмяФормата = "Приват";
ИмяФормата = Метаданные().Имя;