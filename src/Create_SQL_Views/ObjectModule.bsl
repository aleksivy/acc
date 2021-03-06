﻿Перем МассивБулевоПоле;

Функция АвторизацияНаСервере(АгентСервера,Кластер)
	Попытка
		АгентСервера.Authenticate(Кластер,"",""); 
		Возврат Истина;
	Исключение
	КонецПопытки;
	
	Форма = ПолучитьФорму("АвторизацияНаСервере");
	Форма.АгентСервера = АгентСервера;
	Форма.Кластер = Кластер;
	
	Возврат (Форма.ОткрытьМодально(180) = Истина);
	
КонецФункции                      

Функция ПолучитьКластер(АгентСервера,ИмяСервера)
	КластерыСерверов = АгентСервера.GetClusters().Выгрузить();
	Для Каждого Кластер Из КластерыСерверов Цикл
		Если ВРег(Кластер.HostName) <> ВРег(ИмяСервера) Тогда
		ИначеЕсли АвторизацияНаСервере(АгентСервера,Кластер) Тогда
			Возврат Кластер;
		КонецЕсли;
	КонецЦикла;
	Возврат Неопределено;
КонецФункции

Процедура УстановитьИнформационнуюБазу()	
	
	//Получить сервер приложения и имя базы на нем
	Текст = Новый ТекстовыйДокумент;         
	Текст.УстановитьТекст(СтрЗаменить(СтрЗаменить(СтрокаСоединенияИнформационнойБазы(),"""",""),";",Символы.ПС));
	Если Лев(Текст.ПолучитьСтроку(1),5)<>"Srvr=" Тогда
		Сообщить("Для файлового варианта информационной базы обработка не имеет смысла",СтатусСообщения.Внимание);
		Возврат;
	КонецЕсли;

	ИмяСервера = Сред(Текст.ПолучитьСтроку(1),6);
	ИмяБазы = Сред(Текст.ПолучитьСтроку(2),5);
	
	Соединитель = Новый COMОбъект("V83.COMConnector");
	АгентСервера = Соединитель.ConnectAgent(ИмяСервера);  
	
	//Получить кластер серверов
	Кластер = ПолучитьКластер(АгентСервера,ИмяСервера);
	Если Кластер = Неопределено Тогда
		Сообщить("Доступ на сервер приложения 1С запрещен",СтатусСообщения.Внимание);
		Возврат;
	КонецЕсли;
	
	//Получить соединение с рабочим процессом
	РабочиеПроцессы = АгентСервера.GetWorkingProcesses(Кластер).Выгрузить();
	РабочийПроцесс = РабочиеПроцессы[0];
	СоединениеСРабочимПроцессом = Соединитель.ConnectWorkingProcess(РабочийПроцесс.HostName + ":" + Формат(РабочийПроцесс.MainPort, "ЧГ = "));
	
	Форма = ПолучитьФорму("АвторизацияВРабочемПроцессе");
	Форма.СоединениеСРабочимПроцессом = СоединениеСРабочимПроцессом;
	Форма.ИмяБазы = ИмяБазы;
	Форма.ОткрытьМодально(180);

КонецПроцедуры

Процедура УстановитьСтрокуПодключения()
	Если ИнформационнаяБаза = Неопределено Тогда Возврат КонецЕсли;
	
	СтрокаПодключенияSQL = "Provider = SQLNCLI10;"
	 + "Password = Su45oJL7^!WT&J1Ic^;"
	 + "Persist Security Info = True;"
	 + "User ID = sqlggu;"
	 + "Initial Catalog = " + ИнформационнаяБаза.dbName + ";"
	 + "Data Source = " + ИнформационнаяБаза.dbServerName;
	
	СоединениеSQL.ConnectionString = СтрокаПодключенияSQL;
	
Конецпроцедуры

Процедура НастроитьСтрокуПодключения() Экспорт
	Попытка
		СоединениеSQL.ConnectionString = СтрокаПодключенияSQL;
		Диалог = Новый COMОбъект("DataLinks");
		Диалог.PromptEdit(СоединениеSQL);
		СтрокаПодключенияSQL = СоединениеSQL.ConnectionString;
	Исключение
	КонецПопытки;
	
КонецПроцедуры

Функция ПодключитьSQL() Экспорт
	
	//Попытка 
	//	СоединениеSQL.Open();
	//	Возврат Истина;
	//Исключение
	//КонецПопытки;
	
	НастроитьСтрокуПодключения();
	
	Попытка
		СоединениеSQL.Open();
	Исключение
		Сообщить(ОписаниеОшибки(),СтатусСообщения.Внимание);
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	                                            
КонецФункции

Функция ОтключитьSQL() Экспорт
	
	Попытка 
		СоединениеSQL.Close();
	Исключение
		Сообщить(ОписаниеОшибки(),СтатусСообщения.Внимание);
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Процедура СформироватьВьюхи() Экспорт
	
	МассивКонстант = Новый Массив;
	МассивПрочих = Новый Массив;
	
	Для Каждого МетаОбъект Из МассивОбъектовМетаданных Цикл
		
		Если Лев(МетаОбъект.ПолноеИмя(),9) = "Константа" Тогда
			МассивКонстант.Добавить(МетаОбъект.Имя);
		Иначе
			МассивПрочих.Добавить(МетаОбъект);
		КонецЕсли;
		
	КонецЦикла;
	
	СтруктураБД = ПолучитьСтруктуруХраненияБазыДанных(МассивПрочих,Истина);
	
	Для Каждого СтрокаБД Из СтруктураБД Цикл
		
		МетаОбъект = Метаданные.НайтиПоПолномуИмени(СтрокаБД.Метаданные);
		
		Если МетаОбъект=Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ИмяВьюхи = СтрокаБД.ИмяТаблицы;
		Если ПустаяСтрока(ИмяВьюхи) Тогда
			Продолжить;
			//ИмяВьюхи = СтрокаБД.Метаданные + "." + СтрокаБД.Назначение;
		КонецЕсли;
		ИмяВьюхи = СтрЗаменить(ИмяВьюхи,".","_");
			
		СтрокаFrom = СтрЗаменить(СтрокаБД.ИмяТаблицыХранения,".","_");	
		Если ПустаяСтрока(СтрокаFrom) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаSelect = "";
		
		Для Каждого СтрПоле Из СтрокаБД.Поля Цикл
			ДополнитьСтрокуSelect(СтрокаБД.Поля,СтрПоле,СтрокаSelect);
		КонецЦикла;
		
		Если Не ПустаяСтрока(СтрокаSelect) Тогда
			
			СтрокаSelect = Лев(СтрокаSelect,СтрДлина(СтрокаSelect)-1);
			
			Попытка
				
				МетаПеречисление = МетаОбъект.ЗначенияПеречисления;
				
				СтрокаSelect = СтрокаSelect + ", t2.Имя, t2.Синоним";
				СтрокаJoin = "SELECT null [Порядок], null [Имя], null [Синоним]";	
				
				Для ш = 1 По МетаПеречисление.Количество() Цикл
					Значение = МетаПеречисление[ш-1];
					СтрокаJoin = СтрокаJoin + " UNION SELECT " + (ш-1) + ", ''" + Значение.Имя + "'', ''" + Значение.Синоним + "''";
				КонецЦикла;
				
				СтрокаFrom = СтрокаFrom + " t1 INNER JOIN (" + СтрокаJoin + ") t2 ON t1._EnumOrder = t2.Порядок";
				
			Исключение
			КонецПопытки;
			
		КонецЕсли;
		
		ЗаписатьВьюху(ИмяВьюхи,СтрокаSelect,СтрокаFrom);
		
	КонецЦикла;
	
	Если МассивКонстант.Количество()>0 Тогда
		СформироватьВьюхуДляКонстант(МассивКонстант);
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьВьюхуДляКонстант(МассивКонстант)

СтруктураБД = ПолучитьСтруктуруХраненияБазыДанных(,Истина);

Отбор = Новый Структура("ИмяТаблицы","Константы");
СтруктураБД = СтруктураБД.Скопировать(СтруктураБД.НайтиСтроки(Отбор));

Для Каждого СтрокаБД Из СтруктураБД Цикл
	
	СтрокаSelect = "";
	
	Для Каждого стрполей Из СтрокаБД.Поля Цикл
		Если МассивКонстант.Найти(СтрПолей.ИмяПоля)<>Неопределено Тогда
			ДополнитьСтрокуSelect(СтрокаБД.Поля,СтрПолей,СтрокаSelect);
		КонецЕсли;
	КонецЦикла;
	
	Если ПустаяСтрока(СтрокаSelect) Тогда
		Продолжить;
	КонецЕсли;
	
	Если не ПустаяСтрока(СтрокаSelect) Тогда
		СтрокаSelect = Лев(СтрокаSelect,СтрДлина(СтрокаSelect)-1);
	КонецЕсли;
	
	ЗаписатьВьюху("Константы",СтрокаSelect,СтрокаБД.ИмяТаблицыХранения);
	
КонецЦикла;		

КонецПроцедуры

Процедура ДополнитьСтрокуSelect(Поля,Поле,СтрокаSelect)
	
	ИмяПоляХранения	= Поле.ИмяПоляХранения;
	ИмяПоля			= Поле.ИмяПоля;
	МетаПоле		= Метаданные.НайтиПоПолномуИмени(Поле.Метаданные);
	
	ПолеSelect = ИмяПоляХранения;
	ПсевдонимSelect = ИмяПоля;
	
	Если ПустаяСтрока(ИмяПоля) Тогда
		
		Если Прав(ИмяПоляХранения,7)="_IDRRef" Тогда
			ПсевдонимSelect = "Ссылка";
		ИначеЕсли  ИмяПоляХранения= "_KeyField" Тогда
			ПсевдонимSelect = "КлючЗаписи";
		КонецЕсли;
		
	Иначе
		
		Отбор = Новый Структура ("ИмяПоля",ИмяПоля);
		
		Если Поля.НайтиСтроки(Отбор).Количество()>1 Тогда
			
			Текст = Новый ТекстовыйДокумент;
			Текст.УстановитьТекст(СтрЗаменить(ИмяПоляХранения,"_",Символы.ПС+"_"));
			ПсевдонимSelect = ИмяПоля + Текст.ПолучитьСтроку(Текст.КоличествоСтрок());
			
		ИначеЕсли МетаПоле<>Неопределено Тогда
			
			Попытка
				Если МетаПоле.Тип.СодержитТип(Тип("Булево")) Тогда
					ПолеSelect ="CAST(" + ИмяПоляХранения + " AS BIT)";
				КонецЕсли;
			Исключение
			КонецПопытки;
			
			
		ИначеЕсли МассивБулевоПоле.Найти(ИмяПоля)<>Неопределено Тогда
			
			ПолеSelect ="CAST(" +ИмяПоляХранения +" AS BIT)";
			
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокаSelect = СтрокаSelect + ПолеSelect + ?(ПсевдонимSelect="",""," [" +ПсевдонимSelect + "]")+",";
	
КонецПроцедуры

Процедура ЗаписатьВьюху(ИмяВьюхи,СтрокаSelect,СтрокаFrom)
	Текст = "
	|IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = '" + ИмяВьюхи + "') 
	|	DROP VIEW [" + ИмяВьюхи + "]";
	
	Если Не ПустаяСтрока(СтрокаSelect) Тогда
		Текст = Текст + "
		|SET ANSI_NULLS ON 
		|SET QUOTED_IDENTIFIER ON
		|EXEC('CREATE VIEW [dbo].[" + ИмяВьюхи + "] AS SELECT " + СтрокаSelect + " FROM " + СтрокаFrom + "')
		|";
	КонецЕсли;
	
	Попытка
		СоединениеSQL.Execute(Текст);
		Сообщить("Создан dbo." + ИмяВьюхи);
	Исключение
		Сообщить("Ошибка создания dbo." + ИмяВьюхи + "
		|" + ОписаниеОшибки() + "
		|" + Текст,СтатусСообщения.Внимание);
	КонецПопытки;
	
КонецПроцедуры


//************************************************
СоединениеSQL = Новый COMОбъект("ADODB.Connection");
УстановитьИнформационнуюБазу();
УстановитьСтрокуПодключения();

МассивОбъектовМетаданных = Новый Массив;

МассивБулевоПоле = Новый Массив;
МассивБулевоПоле.Добавить("ПометкаУдаления");
МассивБулевоПоле.Добавить("Проведен");
МассивБулевоПоле.Добавить("Предопределенный");
МассивБулевоПоле.Добавить("Предопределенное");
МассивБулевоПоле.Добавить("ЭтоГруппа");
МассивБулевоПоле.Добавить("Забалансовый");
МассивБулевоПоле.Добавить("ТолькоОбороты");
МассивБулевоПоле.Добавить("Активность");
МассивБулевоПоле.Добавить("Сторно");

//МассивБулевоПоле.Добавить("Количественный");
//МассивБулевоПоле.Добавить("Суммовой");
//МассивБулевоПоле.Добавить("НеИспользовать");
//МассивБулевоПоле.Добавить("ЗапретитьИспользоватьВПроводках");

