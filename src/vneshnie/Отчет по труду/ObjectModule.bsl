﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Хранит таблицу значений - состав показателей отчета.
Перем мТаблицаСоставПоказателей Экспорт;

// Хранит структуру - состав показателей отчета,
// значение которых автоматически заполняется по учетным данным.
Перем мСтруктураВариантыЗаполнения Экспорт;

// Хранит структуру многостраничных разделов.
Перем мСтруктураМногостраничныхРазделов Экспорт;

// Хранит дерево значений - структуру листов отчета.
Перем мДеревоСтраницОтчета Экспорт;

// Хранит признак выбора печатных листов.
Перем мЕстьВыбранные Экспорт;

// Хранит имя выбранной формы отчета
Перем мВыбраннаяФорма Экспорт;

// Хранит признак скопированной формы.
Перем мСкопированаФорма Экспорт;

// Хранит ссылку на документ, хранящий данные отчета
Перем мСохраненныйДок Экспорт;

// Следующие переменные хранят границы
// периода построения отчета
Перем мДатаНачалаПериодаОтчета Экспорт;
Перем мДатаКонцаПериодаОтчета  Экспорт;

Перем мТаблицаФормОтчета Экспорт;

Перем мПолноеИмяФайлаВнешнейОбработки Экспорт;
Перем мЗаписьЗапрещена                Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ


////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ 

ОписаниеТиповСтрока15  = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(15);

ОписаниеТиповСтрока254 = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(254);

МассивБулево = Новый Массив;
МассивБулево.Добавить(Тип("Булево"));
ОписаниеТиповБулево    = Новый ОписаниеТипов(МассивБулево);

// Таблица значений хранит состав показателей отчета.
// В колонках таблицы хранятся следующие данные:
//    - имя поля табличного документа;
//    - код показатели по составу показателей;
//    - код показателя по форме (имя области табличного документа);
//    - признак многострочности;
//    - тип данных показателя.
//
мТаблицаСоставПоказателей         = Новый ТаблицаЗначений;
мТаблицаСоставПоказателей.Колонки.Добавить("ИмяПоляТаблДокумента",    ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоСоставу",  ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоФорме",    ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("ПризнМногострочности",    ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("ТипДанныхПоказателя",     ОписаниеТиповСтрока15);

// Таблица значений хранит данные дополнительной страницы многостраничных разделов отчета.
// В колонках таблицы хранятся следующие данные:
//    - имя дополнительной страницы (отображается в списке дополнительных страниц);
//    - булево, признак текущей страницы (отображенной в поле табличного документа);
//    - структура, содержащая имена и значения редактируемых ячеек дополнительной страницы.
//
ТаблицаСтраницыРаздела            = Новый ТаблицаЗначений;
ТаблицаСтраницыРаздела.Колонки.Добавить("Представление",              ОписаниеТиповСтрока254, НСтр("ru='Наименование';uk='Найменування'"));
ТаблицаСтраницыРаздела.Колонки.Добавить("АктивнаяСтраница",           ОписаниеТиповБулево);
ТаблицаСтраницыРаздела.Колонки.Добавить("Данные");

мСтруктураВариантыЗаполнения      = Новый Структура;

ОписаниеТиповСтрока = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(254);

МассивТипов = Новый Массив;
МассивТипов.Добавить(Тип("Дата"));
ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));

мТаблицаФормОтчета = Новый ТаблицаЗначений;
мТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
мТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, НСтр("ru='Утверждена';uk='Затверджена'"),  20);
мТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   НСтр("ru='Действует с';uk='Діє з'"), 5);
мТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   НСтр("ru='         по';uk='         по'"), 5);

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2004Мес9";
НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Госкомстата Украины от 11.08.2004 № 472';uk='Затверджена наказом Держкомстату України від 11.08.2004 № 472'");
НоваяФорма.ДатаНачалоДействия = '20040901';
НоваяФорма.ДатаКонецДействия  = '20071231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2006Кв1";
НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Госкомстата Украины от 12.08.2005 № 236';uk='Затверджена наказом Держкомстату України від 12.08.2005 № 236'");
НоваяФорма.ДатаНачалоДействия = '20060101';
НоваяФорма.ДатаКонецДействия  = '20071231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2008Мес";
НоваяФорма.ОписаниеОтчета     = "Затверджена наказом Держкомстату України від 17.07.2007 N 223";
НоваяФорма.ДатаНачалоДействия = '20080101';
НоваяФорма.ДатаКонецДействия  = '20080731';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2008Кв";
НоваяФорма.ОписаниеОтчета     = "Затверджена наказом Держкомстату України від 17.07.2007 N 223";
НоваяФорма.ДатаНачалоДействия = '20080101';
НоваяФорма.ДатаКонецДействия  = '20091231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2008Мес8";
НоваяФорма.ОписаниеОтчета     = "Затверджена наказом Держкомстату України від 17.07.2007 N 223";
НоваяФорма.ДатаНачалоДействия = '20080801';
НоваяФорма.ДатаКонецДействия  = '20081031';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2008Мес11";
НоваяФорма.ОписаниеОтчета     = "Затверджена наказом Держкомстату України від 17.07.2007 N 223";
НоваяФорма.ДатаНачалоДействия = '20081101';
НоваяФорма.ДатаКонецДействия  = '20091231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2010Мес1";
НоваяФорма.ОписаниеОтчета     = "Затверджена наказом Держкомстату України від 03.08.2009 N 294";
НоваяФорма.ДатаНачалоДействия = '20100101';
НоваяФорма.ДатаКонецДействия  = '20101231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2010Кв";
НоваяФорма.ОписаниеОтчета     = "Затверджена наказом Держкомстату України від 03.08.2009 N 294";
НоваяФорма.ДатаНачалоДействия = '20100101';
НоваяФорма.ДатаКонецДействия  = '20101231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2011Мес";
НоваяФорма.ОписаниеОтчета     = "Затверджена наказом Держкомстату України від 28.07.2010 N 307";
НоваяФорма.ДатаНачалоДействия = '20110101';
НоваяФорма.ДатаКонецДействия  = '20101231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2011Кв";
НоваяФорма.ОписаниеОтчета     = "Затверджена наказом Держкомстату України від 28.07.2010 N 307";
НоваяФорма.ДатаНачалоДействия = '20110101';
НоваяФорма.ДатаКонецДействия  = '20101231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2012Мес";
НоваяФорма.ОписаниеОтчета     = "Затверджена наказом Держкомстату України від 29.06.2011 N 163";
НоваяФорма.ДатаНачалоДействия = '20120101';
НоваяФорма.ДатаКонецДействия  = ОбщегоНазначения.ПустоеЗначениеТипа(Тип("Дата"));

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2012Кв";
НоваяФорма.ОписаниеОтчета     = "Затверджена наказом Держкомстату України від 29.06.2011 N 163";
НоваяФорма.ДатаНачалоДействия = '20120101';
НоваяФорма.ДатаКонецДействия  = '20121231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2013Кв";
НоваяФорма.ОписаниеОтчета     = "Затверджена наказом Держкомстату України від 16.08.2012 N 355";
НоваяФорма.ДатаНачалоДействия = '20130101';
НоваяФорма.ДатаКонецДействия  = ОбщегоНазначения.ПустоеЗначениеТипа(Тип("Дата"));