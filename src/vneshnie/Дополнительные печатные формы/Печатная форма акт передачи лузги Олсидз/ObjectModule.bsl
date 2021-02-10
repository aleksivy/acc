﻿Функция Печать() Экспорт
	
	// Для отладки
	лТест = БИТ_МСФО_Серна.СчетМожноИспользоватьВПроводках("1091");
	лЭтотОбъект = СсылкаНаОбъект;

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_АктПередачиЛузги";
	Макет       = ПолучитьМакет("АктПередачиЛузги");
	
	// шапка акта "УТВЕРЖДАЮ"
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ОбластьМакета.Параметры.ДатаДокументаТекст 	= Формат(лЭтотОбъект.Дата, "ДФ='дд ММММ гггг';Л=uk") + " р.";
	ОбластьМакета.Параметры.Количество			= лЭтотОбъект.Товары.Итог("Количество");
	
	ТабДокумент.Вывести(ОбластьМакета);

	Возврат ТабДокумент;
	
КонецФункции

Функция СведенияОВнешнейОбработке() Экспорт
	ПараметрыРегистрации = Новый Структура;
	МассивНазначений = Новый Массив;
	МассивНазначений.Добавить("Документ.РеализацияТоваровУслуг");
	ПараметрыРегистрации.Вставить("Вид", "ПечатнаяФорма");
	//возможны варианты - ЗаполнениеОбъекта, ДополнительныйОтчет, СозданиеСвязанныхОбъектов,
	ПараметрыРегистрации.Вставить("Назначение", МассивНазначений);
	ПараметрыРегистрации.Вставить("Наименование", "Печатная форма Акт передачи лузги"); //имя под kt обработка зарегистрирована будет в справочнике внешних обработок
	ПараметрыРегистрации.Вставить("Версия", "1.0");
	ПараметрыРегистрации.Вставить("БезопасныйРежим", ЛОЖЬ);
	ПараметрыРегистрации.Вставить("Информация", "Печатная Акт передачи лузги");
	//команды
	ТаблицаКоманд = Новый ТаблицаЗначений;
	ТаблицаКоманд.Колонки.Добавить("Представление"); //как будет выглядеть описание печ.формы для пользователя
	ТаблицаКоманд.Колонки.Добавить("Идентификатор"); //имя нашего макета
	ТаблицаКоманд.Колонки.Добавить("Использование"); //ВызовСерверногоМетода
	ТаблицаКоманд.Колонки.Добавить("ПоказыватьОповещение"); //Истина
	ТаблицаКоманд.Колонки.Добавить("Модификатор"); //ПечатьМХL
	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление = "Печатная форма Акт передачи лузги";
	НоваяКоманда.Идентификатор = "ПечатьАктПередачиЛузги"; //Внешняя печатная форма
	НоваяКоманда.Использование = "ВызовКлиентскогоМетода"; //здесь можно прописать использование как серверного так и клиентского, отличие в том, что серверный метод будет обращаться к экспортной процедуре из модуля объекта, клиентский - к экспортной процедуре из модуля формы объекта
	НоваяКоманда.ПоказыватьОповещение = Истина;
	НоваяКоманда.Модификатор = "ПечатьMXL";
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	Возврат ПараметрыРегистрации;
КонецФункции