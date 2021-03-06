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
		сФайл = Формат(Параметры.Дата,"ДФ=ddMMyyyy") + ".txt";
		Каталог = ПолучитьКаталог(ИмяФайла);
		Возврат Каталог + сФайл;
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
	Длг.Фильтр = "Текстовые файлы (*.txt)|*.txt";
	Длг.Расширение = "txt";   //Параметры.ТекущийТипФайла;
	
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

Функция ПолучитьЗначение(Стр, Рзд = "#")
	Поз = Найти(Стр, Рзд);
	стрРез = Лев(Стр, Поз-1);
	Стр = Сред(Стр, Поз+1);
	Возврат стрРез;
КонецФункции // ПолучитьЗначение

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
		ФайлTXT.Прочитать(ИмяФайла, КодировкаТекста.OEM); //DOS
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
		
		фДК = ПолучитьЗначение(ТекСтрока);
		НомерПП = ПолучитьЗначение(ТекСтрока);
		ПолучитьЗначение(ТекСтрока); // Дата документа
		Сум = Число(ПолучитьЗначение(ТекСтрока));
		//ПолучитьЗначение(ТекСтрока); // Номер строки  //<KOJISI> в приведенном примере этого значения нет, убрал.
		ДатаВыписки = ПолучитьЗначение(ТекСтрока);
		Если ДатаВыписки <> Формат(Параметры.ДатаДок,"ДФ=dd.MM.yyyy") Тогда
			Продолжить;
		КонецЕсли;
		Если фДК = "K" ИЛИ фДК = "К" Тогда // приход  К-английская
			МФО 		= ПолучитьЗначение(ТекСтрока);
			ОКПО 		= ПолучитьЗначение(ТекСтрока);
			РСчет 		= СокрЛП(ПолучитьЗначение(ТекСтрока));
			Контрагент 	= СокрЛП(ПолучитьЗначение(ТекСтрока));
			ПолучитьЗначение(ТекСтрока); //Банк
			ПолучитьЗначение(ТекСтрока); // МФО получателя
			Если СокрЛП(ПолучитьЗначение(ТекСтрока)) <> Параметры.РСчет Тогда // Счет получателя
				Продолжить; // не наш счет
			КонецЕсли;
			
			НовСтрока = тзВыписка.Добавить();
			НовСтрока.ОКПО			= ОКПО;
			НовСтрока.Контрагент	= Контрагент;
			НовСтрока.МФО 			= МФО;
			НовСтрока.РСчет			= РСчет;
			
			Для инд1 = 1 По 3 Цикл
				ПолучитьЗначение(ТекСтрока); // ОКПО получателя, Получатель, Банк получателя
			КонецЦикла;
			НовСтрока.Приход		= Сум;
			НовСтрока.Расход		= 0;
		ИначеЕсли фДК = "Д" Тогда // расход
			ПолучитьЗначение(ТекСтрока); // МФО плательщика
			ПолучитьЗначение(ТекСтрока); // ОКПО плательщика
			Если СокрЛП(ПолучитьЗначение(ТекСтрока)) <> Параметры.РСчет Тогда // Счет плательщика
				Продолжить; // не наш счет
			КонецЕсли;
			ПолучитьЗначение(ТекСтрока); // Плательщик
			ПолучитьЗначение(ТекСтрока); // Банк плательщика
			
			НовСтрока = тзВыписка.Добавить();

			МФО 		= ПолучитьЗначение(ТекСтрока);
			РСчет 		= СокрЛП(ПолучитьЗначение(ТекСтрока));
			ОКПО 		= ПолучитьЗначение(ТекСтрока);
			Контрагент 	= СокрЛП(ПолучитьЗначение(ТекСтрока));
			ПолучитьЗначение(ТекСтрока); //Банк
			
			НовСтрока.Приход		= 0;
			НовСтрока.Расход		= Сум;
			НовСтрока.ОКПО			= ОКПО;
			НовСтрока.Контрагент	= Контрагент;
			НовСтрока.МФО 			= МФО;
			НовСтрока.РСчет			= РСчет;
		Иначе
			Продолжить;
		КонецЕсли;
		НовСтрока.Содержание 	= СокрЛП(ПолучитьЗначение(ТекСтрока)); // Основание платежа
		НовСтрока.НомерПП	 	= НомерПП;

		
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
	Текст = Новый ТекстовыйДокумент;
	Рзд = "#";
	
	Для Каждого Строка из Параметры.тзПлатежныеПоручения Цикл
	    
		ТекСтрока = СокрЛП(Строка.НомерПП) + Рзд;
		ТекСтрока = ТекСтрока + Формат(Строка.ДатаПП,"ДФ=dd.MM.yyyy") + Рзд + Рзд;
		ТекСтрока = ТекСтрока + Формат(Строка.Сумма,"ЧГ=0") + Рзд;
		ТекСтрока = ТекСтрока + Формат(Параметры.НашМФО,"ЧГ=0") + Рзд;
		ТекСтрока = ТекСтрока + Формат(Параметры.НашОКПО,"ЧГ=0") + Рзд + Рзд;
		ТекСтрока = ТекСтрока + СокрЛП(Формат(Параметры.НашСчет,"ЧГ=0")) + Рзд + Рзд;
		ТекСтрока = ТекСтрока + СокрЛП(Параметры.НашаФирма) + Рзд;
		ТекСтрока = ТекСтрока + СокрЛП(Параметры.НашБанк) + Рзд;
		ТекСтрока = ТекСтрока + Формат(Строка.МФО,"ЧГ=0") + Рзд;
		ТекСтрока = ТекСтрока + Формат(Строка.ОКПО,"ЧГ=0") + Рзд;
		ТекСтрока = ТекСтрока + СокрЛП(Формат(Строка.Счет,"ЧГ=0")) + Рзд + Рзд;
		Если Строка.ВидОперации=Перечисления.ВидыОперацийППИсходящее.ПереводНаДругойСчет Тогда
		ТекСтрока = ТекСтрока + СокрЛП(Параметры.НашаФирма) + Рзд;
				Иначе
		ТекСтрока = ТекСтрока + СокрЛП(Строка.Контрагент) + Рзд;
		КонецЕсли;
		ТекСтрока = ТекСтрока + СокрЛП(Строка.Банк) + Рзд + Рзд;
		ТекСтрока = ТекСтрока + СокрЛП(Строка.Содержание) + Рзд;
		
		Текст.ДобавитьСтроку(ТекСтрока);
	КонецЦикла;          
	
	ИмяФайла = Параметры.ИмяФайла;	
	Попытка
		Текст.Записать(ИмяФайла, КодировкаТекста.OEM);
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

ИмяФормата = "УкрСибБанкНовый";

