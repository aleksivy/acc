﻿Функция Печать() Экспорт
	
	// Для отладки
	лТест = БИТ_МСФО_Серна.СчетМожноИспользоватьВПроводках("1091");
	
	Объект = СсылкаНаОбъект;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Ссылка",         СсылкаНаОбъект);
	Запрос.УстановитьПараметр("ТекДата",        СсылкаНаОбъект.МоментВремени());
	Запрос.УстановитьПараметр("ТекОрганизация", СсылкаНаОбъект.Организация);
	Запрос.УстановитьПараметр("Сдал", 			СсылкаНаОбъект.Сдал);
	Запрос.УстановитьПараметр("Принял", 		СсылкаНаОбъект.Принял);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПеремещениеОС.Дата                                   КАК ДатаАкта,
	|	ПеремещениеОС.Номер                                  КАК НомерАкта, 
	|	ПеремещениеОС.ПодразделениеОрганизации.Представление КАК ПринялоПодразделение,
	|	ПеремещениеОС.ПодразделениеОрганизации               КАК ПодразделениеПриняло,
	|	ВЫРАЗИТЬ(ПеремещениеОС.Организация.НаименованиеПолное 
	|	                    КАК СТРОКА(1000))     КАК Организация,
	|	КодыОрганизации.КодПоЕДРПОУ               КАК ЕДРПОУ,
	|	ФИОСдал.Фамилия + "" ""
	|		+ ПОДСТРОКА(ФИОСдал.Имя, 1, 1) + "". ""
	|		+ ПОДСТРОКА(ФИОСдал.Отчество, 1, 1) + "".""               КАК СдалФИО,
	|	ФИОПринял.Фамилия + "" ""
	|		+ ПОДСТРОКА(ФИОПринял.Имя, 1, 1) + "". ""
	|		+ ПОДСТРОКА(ФИОПринял.Отчество, 1, 1) + "".""             КАК ПолучилФИО,
	|	ДолжностьСдал.Должность                                       КАК СдалДолжность,
	|	ДолжностьПринял.Должность                                     КАК ПолучилДолжность
	|ИЗ
	|	Документ.ПеремещениеОС КАК ПеремещениеОС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КодыОрганизации.СрезПоследних(&ТекДата,
	|		                                 Организация = &ТекОрганизация) КАК КодыОрганизации
	|		ПО ПеремещениеОС.Организация = КодыОрганизации.Организация
	|		ЛЕВОЕ СОЕДИНЕНИЕ 
	|			РегистрСведений.РаботникиОрганизаций.СрезПоследних(
	|		                    &ТекДата,
	|		                    Организация = &ТекОрганизация
	|		                    И Сотрудник.Физлицо = &Сдал) КАК ДолжностьСдал
	|		ПО ПеремещениеОС.Организация = ДолжностьСдал.Организация
	|		ЛЕВОЕ СОЕДИНЕНИЕ 
	|			РегистрСведений.РаботникиОрганизаций.СрезПоследних(
	|		                    &ТекДата,
	|		                    Организация = &ТекОрганизация
	|		                    И Сотрудник.Физлицо = &Принял) КАК ДолжностьПринял
	|		ПО ПеремещениеОС.Организация = ДолжностьПринял.Организация
	|		ЛЕВОЕ СОЕДИНЕНИЕ 
	|			РегистрСведений.ФИОФизЛиц.СрезПоследних(
	|			                &ТекДата,
	|			                ФизЛицо = &Сдал) КАК ФИОСдал
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ 
	|			РегистрСведений.ФИОФизЛиц.СрезПоследних(
	|			                &ТекДата,
	|			                ФизЛицо = &Принял) КАК ФИОПринял
	|		ПО (ИСТИНА)
	|
	|ГДЕ
	|	ПеремещениеОС.Ссылка = &Ссылка";
	ВыборкаПоШапке = Запрос.Выполнить().Выбрать();
	ВыборкаПоШапке.Следующий();

	СписокОС = СсылкаНаОбъект.ОС.ВыгрузитьКолонку("ОсновноеСредство");
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Ссылка"        , СсылкаНаОбъект.Ссылка);
	Запрос.УстановитьПараметр("СписокОС"      , СписокОС);
	Запрос.УстановитьПараметр("ТекДата"       , Новый Граница(СсылкаНаОбъект.МоментВремени(), ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("ТекОрганизация", СсылкаНаОбъект.Организация);
	Запрос.УстановитьПараметр("СостояниеВвода", Перечисления.СостоянияОС.ВведеноВЭксплуатацию);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПервоначальныеСведенияБУ.ИнвентарныйНомер КАК ИнвентарныйНомер,
	|	ПервоначальныеСведенияБУ.ПервоначальнаяСтоимость КАК ПервоначальнаяСтоимость,
	|	СчетаБухгалтерскогоУчетаОС.СчетУчета КАК СчетКт,
	|	СчетаБухгалтерскогоУчетаОС.СчетУчета КАК СчетДт,
	|	СчетаБухгалтерскогоУчетаОС.СчетНачисленияАмортизации КАК СчетНачисленияАмортизации,
	|	ПеремещениеОСОС.ОсновноеСредство.НаименованиеПолное КАК НаименованиеОС,
	|	ПеремещениеОСОС.ОсновноеСредство.ЗаводскойНомер КАК ЗаводскойНомер,
	|	ПеремещениеОСОС.ОсновноеСредство.ДатаВыпуска КАК ГодВыпуска,
	|	ПеремещениеОСОС.ОсновноеСредство.НомерПаспорта КАК НомерПаспорта,
	|	МестонахождениеОС.МОЛ.Код КАК КодМОЛа,
	|	МестонахождениеОС.Местонахождение.Представление КАК СдалоПодразделение,
	|	МестонахождениеОС.Местонахождение КАК Подразделение,
	|	СостоянияОС.ДатаСостояния КАК ДатаВвода,
	|	ПараметрыАмортизацииОС.СрокПолезногоИспользования КАК СрокПолезногоИспользования,
	|	ЕСТЬNULL(Амортизация.НачисленнаяАмортизация, 0) КАК НачисленнаяАмортизация
	|ИЗ
	|	Документ.ПеремещениеОС.ОС КАК ПеремещениеОСОС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(
	|				&ТекДата,
	|				ОсновноеСредство В (&СписокОС)
	|					И Организация = &ТекОрганизация) КАК ПервоначальныеСведенияБУ
	|		ПО ПеремещениеОСОС.ОсновноеСредство = ПервоначальныеСведенияБУ.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СчетаБухгалтерскогоУчетаОС.СрезПоследних(
	|				&ТекДата,
	|				ОсновноеСредство В (&СписокОС)
	|					И Организация = &ТекОрганизация) КАК СчетаБухгалтерскогоУчетаОС
	|		ПО ПеремещениеОСОС.ОсновноеСредство = СчетаБухгалтерскогоУчетаОС.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(
	|				&ТекДата,
	|				Организация = &ТекОрганизация
	|					И ОсновноеСредство В (&СписокОС)) КАК МестонахождениеОС
	|		ПО ПеремещениеОСОС.ОсновноеСредство = МестонахождениеОС.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			СостоянияОС.ОсновноеСредство КАК ОсновноеСредство,
	|			СостоянияОС.ДатаСостояния КАК ДатаСостояния
	|		ИЗ
	|			РегистрСведений.СостоянияОСОрганизаций КАК СостоянияОС
	|		ГДЕ
	|			СостоянияОС.Организация = &ТекОрганизация
	|			И СостоянияОС.Состояние = &СостояниеВвода
	|			И СостоянияОС.ОсновноеСредство В(&СписокОС)) КАК СостоянияОС
	|		ПО ПеремещениеОСОС.ОсновноеСредство = СостоянияОС.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыАмортизацииОСБухгалтерскийУчет.СрезПоследних(
	|				&ТекДата,
	|				ОсновноеСредство В (&СписокОС)
	|					И Организация = &ТекОрганизация) КАК ПараметрыАмортизацииОС
	|		ПО ПеремещениеОСОС.ОсновноеСредство = ПараметрыАмортизацииОС.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			Рег.Субконто1 КАК ОсновноеСредство,
	|			Рег.СуммаОстатокКт КАК НачисленнаяАмортизация
	|		ИЗ
	|			РегистрБухгалтерии.Хозрасчетный.Остатки(
	|					&ТекДата,
	|					ПОДСТРОКА(Счет.Код, 1, 2) = ""13"",
	|					,
	|					Субконто1 В (&СписокОС)
	|						И Организация = &ТекОрганизация) КАК Рег) КАК Амортизация
	|		ПО ПеремещениеОСОС.ОсновноеСредство = Амортизация.ОсновноеСредство
	|ГДЕ
	|	ПеремещениеОСОС.Ссылка = &Ссылка
	|";
		
	Результат = Запрос.Выполнить();
	ВыборкаПоОС = Результат.Выбрать();
	
	ТабДокумент   = Новый ТабличныйДокумент();
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПеремещениеОС_ОЗ1";
	Макет         = ПолучитьМакет("ОЗ11");
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();

	ВыборкаПоКомиссии = РаботаСДиалогами.ПолучитьСведенияОКомиссии(СсылкаНаОбъект);
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Параметры     = ОбластьЗаголовок.Параметры;
	Параметры.Заполнить(ВыборкаПоШапке);
	Параметры.Организация = СокрП(ВыборкаПоШапке.Организация);
	Параметры.Валюта      = ВалютаРегламентированногоУчета;
	Параметры.НомерАкта   = ОбщегоНазначения.ПолучитьНомерНаПечать(СсылкаНаОбъект);
	Параметры.КодМОЛа	  = СокрП(СсылкаНаОбъект.МОЛОрганизации.Код);
	Параметры.ВидОперации = "Внутр. перемі-" + Символы.ПС + "щення";
	ТабДокумент.Вывести(ОбластьЗаголовок);
	Пока ВыборкаПоОС.Следующий() Цикл
		ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
		Параметры     = ОбластьСтрока.Параметры;
		Параметры.Заполнить(ВыборкаПоШапке);
		Параметры.Заполнить(ВыборкаПоОС);
		ТабДокумент.Вывести(ОбластьСтрока);
	КонецЦикла;
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	Параметры     = ОбластьПодвал.Параметры;
	Параметры.Заполнить(ВыборкаПоШапке);
	Параметры.Заполнить(ВыборкаПоКомиссии);
	ТабДокумент.Вывести(ОбластьПодвал);

	ТабДокумент.ОбластьПечати = ТабДокумент.Область(2, 2, ТабДокумент.ВысотаТаблицы, ТабДокумент.ШиринаТаблицы);
	Возврат ТабДокумент;
КонецФункции

Функция СведенияОВнешнейОбработке() Экспорт
	ПараметрыРегистрации = Новый Структура;
	МассивНазначений = Новый Массив;
	МассивНазначений.Добавить("Документ.ПеремещениеОС");
	ПараметрыРегистрации.Вставить("Вид", "ПечатнаяФорма");
	//возможны варианты - ЗаполнениеОбъекта, ДополнительныйОтчет, СозданиеСвязанныхОбъектов,
	ПараметрыРегистрации.Вставить("Назначение", МассивНазначений);
	ПараметрыРегистрации.Вставить("Наименование", "Печатная форма ОЗ1 для акта по многим ОС"); //имя под kt обработка зарегистрирована будет в справочнике внешних обработок
	ПараметрыРегистрации.Вставить("Версия", "1.0");
	ПараметрыРегистрации.Вставить("БезопасныйРежим", ЛОЖЬ);
	ПараметрыРегистрации.Вставить("Информация", "Печатная форма ОЗ1 для акта по многим ОС");
	//команды
	ТаблицаКоманд = Новый ТаблицаЗначений;
	ТаблицаКоманд.Колонки.Добавить("Представление"); //как будет выглядеть описание печ.формы для пользователя
	ТаблицаКоманд.Колонки.Добавить("Идентификатор"); //имя нашего макета
	ТаблицаКоманд.Колонки.Добавить("Использование"); //ВызовСерверногоМетода
	ТаблицаКоманд.Колонки.Добавить("ПоказыватьОповещение"); //Истина
	ТаблицаКоманд.Колонки.Добавить("Модификатор"); //ПечатьМХL
	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление = "Печатная форма ОЗ1 для акта по многим ОС";
	НоваяКоманда.Идентификатор = "ПечатьОЗ11"; //Внешняя печатная форма
	НоваяКоманда.Использование = "ВызовКлиентскогоМетода"; //здесь можно прописать использование как серверного так и клиентского, отличие в том, что серверный метод будет обращаться к экспортной процедуре из модуля объекта, клиентский - к экспортной процедуре из модуля формы объекта
	НоваяКоманда.ПоказыватьОповещение = Истина;
	НоваяКоманда.Модификатор = "ПечатьMXL";
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	Возврат ПараметрыРегистрации;
КонецФункции
