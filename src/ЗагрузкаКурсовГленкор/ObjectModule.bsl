﻿Перем мUSDhist;
Перем мEUR;

Перем ИмяФайла;
Перем СтрокаПараметраПолучения;
Перем ИмяВходящегоФайла;
Перем ОшибкаКодаСервера;
Перем мадоСоединение Экспорт;

Функция ЗапросКурсаНаДату(дтДатаКурса, спКодВалюты, пВалюта, пВалютаПриведения) Экспорт
	
	тзРезультат = Новый ТаблицаЗначений; 
	тзРезультат.Колонки.Добавить("currency_code");
	тзРезультат.Колонки.Добавить("exchange_date");
	тзРезультат.Колонки.Добавить("exchange_rate");
	тзРезультат.Колонки.Добавить("exchange_factor");
	тзРезультат.Колонки.Добавить("multiply_divide");
	
	
	адоНаборДанных   = Новый COMОбъект("ADODB.RecordSet");
	адоНаборДанных.Open("exec exrates.dbo.sp_GetRate '" + Формат(дтДатаКурса,"ДФ=yyyyMMdd")+"'", мадоСоединение);	
	
	Пока НЕ адоНаборДанных.EOF() Цикл 
		
		стртзРезультат 					= тзРезультат.Добавить();
		стртзРезультат.currency_code	= адоНаборДанных.Fields("currency_code").Value; 
		стртзРезультат.exchange_date 	= адоНаборДанных.Fields("exchange_date").Value; 
		
		стртзРезультат.exchange_rate 	= адоНаборДанных.Fields("exchange_rate").Value; 
		стртзРезультат.exchange_factor 	= адоНаборДанных.Fields("exchange_factor").Value; 
		стртзРезультат.multiply_divide 	= адоНаборДанных.Fields("multiply_divide").Value; 
		
		адоНаборДанных.MoveNext();	
		
	КонецЦикла;
	
	Для Каждого стрЭл Из тзРезультат Цикл
		Если (стрЭл.currency_code = спКодВалюты) Тогда
			ЗаписатьВалюту(стрЭл, пВалюта, пВалютаПриведения);
			Прервать;
		КонецЕсли;	
	КонецЦикла;
				
КонецФункции	

Функция ЗаписатьВалюту(структКурс, Валюта, ВалютаПриведения = Неопределено)
	Если ВалютаПриведения = Неопределено Тогда ВалютаПриведения = Справочники.Валюты.Гривна; КонецЕсли;
	
	рсКурсыВалют = РегистрыСведений.КурсыВалют.СоздатьМенеджерЗаписи();
	рсКурсыВалют.Период		= Дата(структКурс.exchange_date);
	рсКурсыВалют.Валюта		= Валюта;
	рсКурсыВалют.ВалютаПриведения  	= ВалютаПриведения;
	рсКурсыВалют.Прочитать();
	Если (рсКурсыВалют.Курс = 0) или (рсКурсыВалют.Курс = Null) или (рсКурсыВалют.Курс = Неопределено) Тогда
		рсКурсыВалют.Период		= Дата(структКурс.exchange_date);
		рсКурсыВалют.Валюта		= Валюта;
		рсКурсыВалют.ВалютаПриведения  	= ВалютаПриведения;
		Если НЕ структКурс.exchange_factor = 0  Тогда
			рсКурсыВалют.Курс 		= Окр((структКурс.exchange_rate * 100) / структКурс.exchange_factor,4);
			рсКурсыВалют.Кратность	= 100;
		КонецЕсли;
		
		Попытка
			рсКурсыВалют.Записать();
		Исключение
			Возврат Ложь;
		КонецПопытки;
	КонецЕсли;

	Возврат Истина;
	
КонецФункции	

Процедура Загрузить_USDhist()
	
	мадоСоединение = Новый COMОбъект("ADODB.Connection");
	Попытка
		мадоСоединение.Open("Provider=SQLOLEDB.1;Persist Security Info=False;User ID=exrates-ro;Password= glencore;Data Source=UAIEVSRV00401");
	Исключение	        
		мадоСоединение = Неопределено;	
		Возврат;
	КонецПопытки;
	
	лКодВалюты = "UAH";
	лВалюта = мUSDhist;
	лВалютаПриведения = Справочники.Валюты.Гривна;
	зпЗапрос = Новый Запрос;
	зпЗапрос.УстановитьПараметр("Валюта", лВалюта );
	зпЗапрос.УстановитьПараметр("ВалютаПриведения", лВалютаПриведения );
	зпЗапрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	МАКСИМУМ(Рег.Период) КАК Период
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(
	|			,
	|			Валюта = &Валюта
	|				И ВалютаПриведения = &ВалютаПриведения) КАК Рег
	|";	
					 
	лтзЗапрос = зпЗапрос.Выполнить().Выгрузить();
	Если НЕ лтзЗапрос.Количество() = 0 Тогда
		дтТекДата = КонецДня( лтзЗапрос[0].Период ) + 1;
		Пока НачалоДня(дтТекДата) <= НачалоДня(ТекущаяДата()) Цикл
			ЗапросКурсаНаДату(дтТекДата, лКодВалюты, лВалюта, лВалютаПриведения);
			дтТекДата = КонецДня( дтТекДата ) + 1;
		КонецЦикла;	
	КонецЕсли;
	
	лКодВалюты = "EUR";
	лВалюта = мEUR;
	лВалютаПриведения = мUSDhist;
	зпЗапрос = Новый Запрос;
	зпЗапрос.УстановитьПараметр("Валюта", лВалюта );
	зпЗапрос.УстановитьПараметр("ВалютаПриведения", лВалютаПриведения );
	зпЗапрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	МАКСИМУМ(Рег.Период) КАК Период
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(
	|			,
	|			Валюта = &Валюта
	|				И ВалютаПриведения = &ВалютаПриведения) КАК Рег
	|";	
					 
	лтзЗапрос = зпЗапрос.Выполнить().Выгрузить();
	Если НЕ лтзЗапрос.Количество() = 0 Тогда
		дтТекДата = КонецДня( лтзЗапрос[0].Период ) + 1;
		Пока НачалоДня(дтТекДата) <= НачалоДня(ТекущаяДата()) Цикл
			ЗапросКурсаНаДату(дтТекДата, лКодВалюты, лВалюта, лВалютаПриведения);
			дтТекДата = КонецДня( дтТекДата ) + 1;
		КонецЦикла;	
	КонецЕсли;
	
	Если НЕ мадоСоединение = Неопределено Тогда
		мадоСоединение.Close();
	КонецЕсли;
КонецПроцедуры

// Производит загрузку курсов и кратностей валют с сайта finance.ua
//
// Параметры:
//  ИндикаторФормы     - ЭлементыФормы типа Индикатор - для отработки индикатора формы
//  НадписьВалютыФормы - ЭлементыФормы типа Надпись  - Для отработки надписи 
//													   загружаемой валюты
//
Процедура ЗагрузитьКурсыНБУ() Экспорт
Перем HTTP;
	
	РегистрКурсыВалют = РегистрыСведений.КурсыВалют;
	ЗаписьКурсовВалют = РегистрКурсыВалют.СоздатьМенеджерЗаписи();

	Текст = Новый ТекстовыйДокумент();

	ВремКаталог = КаталогВременныхФайлов() + "tempKurs";
	//ИмяФайла = "Curses.txt";
	СоздатьКаталог(ВремКаталог);
	УдалитьФайлы(ВремКаталог,"*.*");
	
	лтзВалюты = Новый ТаблицаЗначений;
	лтзВалюты.Колонки.Добавить("Валюта", Новый ОписаниеТипов("СправочникСсылка.Валюты"));
	лтзВалюты.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата", Новый КвалификаторыДаты(ЧастиДаты.Дата)));
	лНоваяСтрока = лтзВалюты.Добавить(); лНоваяСтрока.Период = ТекущаяДата(); лНоваяСтрока.Валюта = Справочники.Валюты.Доллар;
	лНоваяСтрока = лтзВалюты.Добавить(); лНоваяСтрока.Период = ТекущаяДата(); лНоваяСтрока.Валюта = Справочники.Валюты.НайтиПоКоду("978");
	лтзВалюты2 = лтзВалюты.СкопироватьКолонки();
	
	Для каждого лСтрока Из лтзВалюты Цикл
		ИмяВходящегоФайла = "" + ВремКаталог + "\" + Строка(Новый УникальныйИдентификатор) + ".xml";
		ТекВалюта = лСтрока.Валюта;
		дтТекДата = лСтрока.Период;
		#Если Клиент Тогда
			Сообщить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Загружается курс для %1 (код %2).", СокрЛП(ТекВалюта.Наименование), ТекВалюта.Код)); 	
		#КонецЕсли	
		
		Дата   = Формат(Год(дтТекДата),"ЧРГ=; ЧГ=0")+Формат(Месяц(дтТекДата),"ЧЦ=2;ЧДЦ=0;ЧВН=")+Формат(День(дтТекДата),"ЧЦ=2;ЧДЦ=0;ЧВН=");
		СтрокаПараметраПолучения = "/NBUStatService/v1/statdirectory/exchange?valcode="+ ВРег(ТекВалюта.Наименование) + "&date=" + Дата;
		
		Если ЗапроситьФайлыССервера(СтрокаПараметраПолучения, ИмяВходящегоФайла, HTTP) <> Истина Тогда
			// Запомним валюту для которой не удалось загрузить курс с первого раза
			лНоваяСтрока = лтзВалюты2.Добавить();
			ЗаполнитьЗначенияСвойств(лНоваяСтрока, лСтрока);
			#Если Клиент Тогда
				Сообщить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Не удалось получить ресурс для валюты %1 (код %2). Курс для валюты не загружен.", СокрЛП(ТекВалюта.Наименование), ТекВалюта.Код)); 
			#КонецЕсли	
			Если ОшибкаКодаСервера Тогда Прервать; КонецЕсли;
			Продолжить;
		КонецЕсли; 
		
		Текст = Новый ЧтениеXML();
		Текст.ОткрытьФайл(ИмяВходящегоФайла);
		Пока Текст.Прочитать() Цикл 
			Если Текст.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда 
				ИмяУзла = Текст.Имя; 
			ИначеЕсли Текст.ТипУзла = ТипУзлаXML.Текст Тогда 
				Если ИмяУзла = "rate" Тогда
					Сообщить(" " + Формат(дтТекДата, "ДФ=dd.MM.yyyy")  + " : " + ТекВалюта.Наименование + " : " + Текст.Значение);
					Если ТекВалюта <> Справочники.Валюты.ПустаяСсылка()  Тогда
						ЗаписьКурсовВалют.Валюта = ТекВалюта;
						ЗаписьКурсовВалют.Период = дтТекДата;
						ЗаписьКурсовВалют.Прочитать();
						ЗаписьКурсовВалют.Валюта    = ТекВалюта;
						ЗаписьКурсовВалют.Период    = дтТекДата;
						ЗаписьКурсовВалют.Курс      = Число(Текст.Значение) * 100;
						ЗаписьКурсовВалют.ВалютаПриведения = Справочники.Валюты.Гривна; 
						ЗаписьКурсовВалют.Кратность = 100;
						ЗаписьКурсовВалют.Записать(Истина);
					КонецЕсли; 
				КонецЕсли; 
			ИначеЕсли Текст.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда 
			КонецЕсли; 
		КонецЦикла;
		
		#Если Клиент Тогда	
			Сообщить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Курс для %1 (код %2) загружен.", СокрЛП(ТекВалюта.Наименование), ТекВалюта.Код)); 	
		#КонецЕсли
	КонецЦикла;
	// Иногда с первого раза курс не загружается. Попробуем еще раз 
	Для каждого лСтрока Из лтзВалюты2 Цикл
		ИмяВходящегоФайла = "" + ВремКаталог + "\" + Строка(Новый УникальныйИдентификатор) + ".xml";
		ТекВалюта = лСтрока.Валюта;
		дтТекДата = лСтрока.Период;
		#Если Клиент Тогда
			Сообщить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Загружается курс для %1 (код %2).", СокрЛП(ТекВалюта.Наименование), ТекВалюта.Код)); 	
		#КонецЕсли	
		
		Дата   = Формат(Год(дтТекДата),"ЧРГ=; ЧГ=0")+Формат(Месяц(дтТекДата),"ЧЦ=2;ЧДЦ=0;ЧВН=")+Формат(День(дтТекДата),"ЧЦ=2;ЧДЦ=0;ЧВН=");
		СтрокаПараметраПолучения = "/NBUStatService/v1/statdirectory/exchange?valcode="+ ВРег(ТекВалюта.Наименование) + "&date=" + Дата;
		
		Если ЗапроситьФайлыССервера(СтрокаПараметраПолучения, ИмяВходящегоФайла, HTTP) <> Истина Тогда
			лНоваяСтрока = лтзВалюты2.Добавить();
			ЗаполнитьЗначенияСвойств(лНоваяСтрока, лСтрока);
			#Если Клиент Тогда
				Сообщить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Не удалось получить ресурс для валюты %1 (код %2). Курс для валюты не загружен.", СокрЛП(ТекВалюта.Наименование), ТекВалюта.Код)); 
			#КонецЕсли	
			Если ОшибкаКодаСервера Тогда Прервать; КонецЕсли;
			Продолжить;
		КонецЕсли; 
		
		Текст = Новый ЧтениеXML();
		Текст.ОткрытьФайл(ИмяВходящегоФайла);
		Пока Текст.Прочитать() Цикл 
			Если Текст.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда 
				ИмяУзла = Текст.Имя; 
			ИначеЕсли Текст.ТипУзла = ТипУзлаXML.Текст Тогда 
				Если ИмяУзла = "rate" Тогда
					Сообщить(" " + Формат(дтТекДата, "ДФ=dd.MM.yyyy")  + " : " + ТекВалюта.Наименование + " : " + Текст.Значение);
					Если ТекВалюта <> Справочники.Валюты.ПустаяСсылка()  Тогда
						ЗаписьКурсовВалют.Валюта = ТекВалюта;
						ЗаписьКурсовВалют.Период = дтТекДата;
						ЗаписьКурсовВалют.Прочитать();
						ЗаписьКурсовВалют.Валюта    = ТекВалюта;
						ЗаписьКурсовВалют.Период    = дтТекДата;
						ЗаписьКурсовВалют.Курс      = Число(Текст.Значение) * 100;
						ЗаписьКурсовВалют.ВалютаПриведения = Справочники.Валюты.Гривна; 
						ЗаписьКурсовВалют.Кратность = 100;
						ЗаписьКурсовВалют.Записать(Истина);
					КонецЕсли; 
				КонецЕсли; 
			ИначеЕсли Текст.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда 
			КонецЕсли; 
		КонецЦикла;
		
		#Если Клиент Тогда	
			Сообщить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Курс для %1 (код %2) загружен.", СокрЛП(ТекВалюта.Наименование), ТекВалюта.Код)); 	
		#КонецЕсли
	КонецЦикла;

	//УдалитьФайлы(ВремКаталог,"*.*");
	
	// Если загружаются курсы за понедельник, надо проверить курсы за субботу-воскресенье
	Если Не (ДеньНедели(ТекущаяДата()) = 1) Тогда Возврат; КонецЕсли;
	лДатаВоскресенье = НачалоДня( НачалоДня(ТекущаяДата()) - 1 );
	лДатаСуббота = НачалоДня( НачалоДня(лДатаВоскресенье) - 1 );
	// Проверяем курсы
	лсзВалюты = Новый СписокЗначений; лсзВалюты.Добавить( Справочники.Валюты.Доллар ); лсзВалюты.Добавить( Справочники.Валюты.НайтиПоКоду("978") );
	лсзДаты = Новый СписокЗначений; лсзДаты.Добавить( лДатаСуббота ); лсзДаты.Добавить( лДатаВоскресенье );
	Для каждого лЗначВалюты Из лсзВалюты Цикл
		лВалютаТут = лЗначВалюты.Значение;
		лОтбор = Новый Структура; лОтбор.Вставить("Валюта", лВалютаТут); лОтбор.Вставить("ВалютаПриведения", Справочники.Валюты.Гривна);
		лКурсыТекущие = РегистрыСведений.КурсыВалют.СрезПоследних( лДатаСуббота, лОтбор );
		Если (лКурсыТекущие.Количество()=1) Тогда
			лКурс = лКурсыТекущие[0].Курс;
			лКратность = лКурсыТекущие[0].Кратность;
			Для каждого лЗначДаты Из лсзДаты Цикл
				лДатаТут = лЗначДаты.Значение;
				лМенеджерЗаписи = РегистрыСведений.КурсыВалют.СоздатьМенеджерЗаписи();
				лМенеджерЗаписи.Период = лДатаТут;
				лМенеджерЗаписи.Валюта = лВалютаТут;
				лМенеджерЗаписи.ВалютаПриведения = Справочники.Валюты.Гривна;
				лМенеджерЗаписи.Прочитать();
				Если Не лМенеджерЗаписи.Выбран() Тогда
					лМенеджерЗаписи.Период = лДатаТут;
					лМенеджерЗаписи.Валюта = лВалютаТут;
					лМенеджерЗаписи.ВалютаПриведения = Справочники.Валюты.Гривна;
					лМенеджерЗаписи.Курс = лКурс;
					лМенеджерЗаписи.Кратность = лКратность;
					лМенеджерЗаписи.Записать();
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // ЗагрузитьКурсы()

// Функция получает файлы с сервера с указанными параметрами и сохраняет на диск
//
// Параметры:
//  HTTP - HTTPСоединение, если приходится использовать данную функцию в цикле, то тут передается
//         переменная с созданным в предыдущей итерации цикла HTTPСоединением
// СерверИсточникПараметр - Строка, сервер, с которого необходимо получить файлы
// СтрокаПараметраПолученияПараметр - Строка, адрес ресурса на сервере.
// ИмяВходящегоФайлаПараметр - Имя файла, в который помещаются данные полученного ресурса.
//
// Возвращаемое значение:
//  Булево - Успешно получены файлы или нет.
//
Функция ЗапроситьФайлыССервера(СтрокаПараметраПолученияПараметр, ИмяВходящегоФайлаПараметр, HTTP = Неопределено)
	
	СтрокаПараметраПолучения = СтрокаПараметраПолученияПараметр;
	ИмяВходящегоФайла        = ИмяВходящегоФайлаПараметр;
	
	#Если Клиент Тогда
		ФормаОшибки = ЭтотОбъект.ПолучитьФорму("ФормаОшибки"); 
	#КонецЕсли	
	
	Если ТипЗнч(HTTP) <> Тип("HTTPСоединение") Тогда
		//HTTP = Новый HTTPСоединение("fin.1c.ua"); 
		
		ssl4 = Новый ЗащищенноеСоединениеOpenSSL( Неопределено, Неопределено );
		HTTP = Новый HTTPСоединение("bank.gov.ua",,,,,,ssl4); 
	КонецЕсли; 
	
	Попытка
		HTTP.Получить(СтрокаПараметраПолучения, ИмяВходящегоФайла);
		Возврат Истина;
	Исключение
		СтрОписаниеОшибки = ОписаниеОшибки(); 
		Если ПустаяСтрока(СтрОписаниеОшибки) <> 0 Тогда
			лИмяТекущейСтраницы = "0";
			ОшибкаКодаСервера = Истина;
		ИначеЕсли Найти(СтрОписаниеОшибки, "407") <> 0 И Найти(НРег(СтрОписаниеОшибки), "unauthorized") <> 0 Тогда
			лИмяТекущейСтраницы = "407";
			ОшибкаКодаСервера = Истина;
		ИначеЕсли Найти(СтрОписаниеОшибки, "402") <> 0 Тогда
			лИмяТекущейСтраницы = "402";
			ОшибкаКодаСервера = Истина;
		ИначеЕсли Найти(СтрОписаниеОшибки, "403") <> 0 Тогда
			лИмяТекущейСтраницы = "403";
			ОшибкаКодаСервера = Истина;
		ИначеЕсли Найти(СтрОписаниеОшибки, "500") <> 0 Тогда
			лИмяТекущейСтраницы = "500";
			ОшибкаКодаСервера = Истина;
		Иначе
			ОшибкаКодаСервера = Ложь;
			Возврат Ложь;
		КонецЕсли;
		#Если Клиент Тогда
			ФормаОшибки.Панель.ТекущаяСтраница = ФормаОшибки.Панель.Страницы[ "Страница" + лИмяТекущейСтраницы ];
			ФормаОшибки.ОткрытьМодально();
		#КонецЕсли	
	КонецПопытки;
	

КонецФункции

// Выделяет из переданной строки первое значение
 //  до символа "TAB"
 //
 // Параметры: 
 //  ИсходнаяСтрока - Строка - строка для разбора
 //
 // Возвращаемое значение:
 //  подстроку до символа "TAB"
 //
Функция ВыделитьПодСтроку(ИсходнаяСтрока)

	Перем ПодСтрока;
	
    Поз = Найти(ИсходнаяСтрока,Символы.Таб);
	Если Поз > 0 Тогда
		ПодСтрока = Лев(ИсходнаяСтрока,Поз-1);
		ИсходнаяСтрока = Сред(ИсходнаяСтрока,Поз+1);
	Иначе
		ПодСтрока = ИсходнаяСтрока;
		ИсходнаяСтрока = "";
	КонецЕсли;
	
	Возврат ПодСтрока;
 
 КонецФункции // ВыделитьПодСтроку()

Процедура Инициализировать() Экспорт
	Если Не НеЗагружатьUSDHist Тогда
		Загрузить_USDhist();
	КонецЕсли;
	Если Не НеЗагружатьКурсыНБУ Тогда
		ЗагрузитьКурсыНБУ();
	КонецЕсли;
КонецПроцедуры

мUSDhist = глЗначениеПеременной("ВалютаУчетаМСФО");
мEUR = Справочники.Валюты.НайтиПоКоду("978");
