﻿Перем СтруктураКодов Экспорт;

//Функция закодирует строку в формате code128
//
//Параметры:
// Строка - текст
//Возвращаемое значение:
// Строка
Функция Code_Char(Строка)
	Результат = "";
	Если Не ЗначениеЗаполнено(Строка) Тогда
		Возврат Результат;
	КонецЕсли;	
	
	Если Строка = "211412" Тогда
		Результат = "A";
	ИначеЕсли Строка = "211214" Тогда
		Результат = "B";
	ИначеЕсли Строка = "211232" Тогда
		Результат = "C";
	ИначеЕсли Строка = "2331112" Тогда
		Результат = "@";	
	Иначе
		ДлинаСтроки = СтрДлина(Строка);
		Для н = 0 По ДлинаСтроки / 2 Цикл
			ТекСтрока = Сред(Строка, 2 * н + 1, 2);
			
			Если ТекСтрока = "11" Тогда
				Результат = Результат + "0";
			ИначеЕсли ТекСтрока = "21" Тогда
				Результат = Результат + "1";
			ИначеЕсли ТекСтрока = "31" Тогда
				Результат = Результат + "2";
			ИначеЕсли ТекСтрока = "41" Тогда
				Результат = Результат + "3";
			ИначеЕсли ТекСтрока = "12" Тогда
				Результат = Результат + "4";
			ИначеЕсли ТекСтрока = "22" Тогда
				Результат = Результат + "5";
			ИначеЕсли ТекСтрока = "32" Тогда
				Результат = Результат + "6";
			ИначеЕсли ТекСтрока = "42" Тогда
				Результат = Результат + "7";
			ИначеЕсли ТекСтрока = "13" Тогда
				Результат = Результат + "8";
			ИначеЕсли ТекСтрока = "23" Тогда
				Результат = Результат + "9";
			ИначеЕсли ТекСтрока = "33" Тогда
				Результат = Результат + ":";
			ИначеЕсли ТекСтрока = "43" Тогда
				Результат = Результат + ";";
			ИначеЕсли ТекСтрока = "14" Тогда
				Результат = Результат + "<";
			ИначеЕсли ТекСтрока = "24" Тогда
				Результат = Результат + "=";
			ИначеЕсли ТекСтрока = "34" Тогда
				Результат = Результат + ">";
			ИначеЕсли ТекСтрока = "44" Тогда
				Результат = Результат + "?";
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

//Функция переводит строку в формат code128
// для шрифта Barcode
//Параметры:
//  Строка - тип Строка
//Возвращаемое значение:
// Строка
Функция code128(Строка) Экспорт
	МассивКодов = Новый Массив(1024);
    ИндексМассива  = 0;
    ТекущийРежим = "";
    Символ1 = 0;
    Символ2 = 0;
    н = 1;
    ДлинаСтроки = СтрДлина(Строка);
    КонтрольныйКод = 0;
    Результат = "";
	
	Пока н <= ДлинаСтроки Цикл
		//Текущий символ в строке
        Символ1 = КодСимвола(Сред(Строка, н, 1));
        н = н + 1;
        //Разбираем только символы от 0 до 127
		Если Символ1 <= 127 Тогда
			 //Следующий символ
            Если н <= ДлинаСтроки Тогда
                Символ2 = КодСимвола(Сред(Строка, н, 1));
            Иначе
                Символ2 = 0;
            КонецЕсли;
			
			//Пара цифр - режим С
			Если (48 <= Символ1) И (Символ1 <= 57) И (48 <= Символ2) И (Символ2 <= 57) Тогда
				н = н + 1;
                Если ИндексМассива = 0 Тогда
                    //Начало с режима С
                    ТекущийРежим = "C";
                    МассивКодов[ИндексМассива] = 105;
                    ИндексМассива = ИндексМассива + 1;
                ИначеЕсли ТекущийРежим <> "C" Тогда
                    //Переключиться на режим С
                    ТекущийРежим = "C";
                    МассивКодов[ИндексМассива] = 99;
                    ИндексМассива = ИндексМассива + 1;
                КонецЕсли;
                //Добавить символ режима С
                МассивКодов[ИндексМассива] = Число(Символ(Символ1) + Символ(Символ2));
                ИндексМассива = ИндексМассива + 1;
			Иначе
				Если ИндексМассива = 0 ТОгда
					Если Символ1 < 32 Тогда
						//Начало с режима A
						ТекущийРежим = "A";
						МассивКодов[ИндексМассива] = 10;
						ИндексМассива = ИндексМассива + 1;
					Иначе
						//Начало с режима B
						ТекущийРежим = "B";
						МассивКодов[ИндексМассива] = 104;
						ИндексМассива = ИндексМассива + 1 ;
					КонецЕсли;
				КонецЕсли;
				
				//Переключение по надобности в режим A
				Если (Символ1 < 32) И (ТекущийРежим <> "A") Тогда
					ТекущийРежим = "A";
					МассивКодов[ИндексМассива] = 101;
					ИндексМассива = ИндексМассива + 1;
					//Переключение по надобности в режим B
				ИначеЕсли ((64 <= Символ1) И (ТекущийРежим <> "B")) Или (ТекущийРежим = "C") Тогда
					ТекущийРежим = "B";
					МассивКодов[ИндексМассива] = 100;
					ИндексМассива = ИндексМассива + 1;
				КонецЕсли;
				
				//Служебные символы
				Если (Символ1 < 32) Тогда
					МассивКодов[ИндексМассива] = Символ1 + 64;
					ИндексМассива = ИндексМассива + 1;
					//Все другие символы
				Иначе
					МассивКодов[ИндексМассива] = Символ1 - 32;
					ИндексМассива = ИндексМассива + 1;
				КонецЕсли;
			КонецЕсли;			
		КонецЕсли;		
	КонецЦикла;
	
	//Подсчитываем контрольную сумму
	
	КонтрольныйКод = МассивКодов[0] % 103;
    Для н = 1 По ИндексМассива - 1 Цикл
        КонтрольныйКод = (КонтрольныйКод + МассивКодов[н] * н) % 103;
	КонецЦикла;
    
    МассивКодов[ИндексМассива] = КонтрольныйКод;
    ИндексМассива = ИндексМассива + 1;
    //Завершающий символ
    МассивКодов[ИндексМассива] = 106;
    ИндексМассива = ИндексМассива + 1;
	
	//Собираем строку символов шрифта
	Для н = 0 По ИндексМассива - 1 Цикл
		Результат = Результат + Code_Char(Code_128_ID(МассивКодов[н]))
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

//Функция
//
//Параметры:
//
//Возвращаемое значение:
//
Функция Code_128_ID(Число)
	Результат = "";
	
	Результат = СтруктураКодов.Получить(Число);
	
	Возврат Результат;
КонецФункции




/////////////////////////////////////////////////////
СтруктураКодов = Новый Соответствие;
СтруктураКодов.Вставить(0, "212222");
СтруктураКодов.Вставить(1, "222122");
СтруктураКодов.Вставить(2, "222221");
СтруктураКодов.Вставить(3, "121223");
СтруктураКодов.Вставить(4, "121322");
СтруктураКодов.Вставить(5, "131222");
СтруктураКодов.Вставить(6, "122213");
СтруктураКодов.Вставить(7, "122312");
СтруктураКодов.Вставить(8, "132212");
СтруктураКодов.Вставить(9, "221213");
СтруктураКодов.Вставить(10, "221312");
СтруктураКодов.Вставить(11, "231212");
СтруктураКодов.Вставить(12, "112232");
СтруктураКодов.Вставить(13, "122132");
СтруктураКодов.Вставить(14, "122231");
СтруктураКодов.Вставить(15, "113222");
СтруктураКодов.Вставить(16, "123122");
СтруктураКодов.Вставить(17, "123221");
СтруктураКодов.Вставить(18, "223211");
СтруктураКодов.Вставить(19, "221132");
СтруктураКодов.Вставить(20, "221231");
СтруктураКодов.Вставить(21, "213212");
СтруктураКодов.Вставить(22, "223112");
СтруктураКодов.Вставить(23, "312131");
СтруктураКодов.Вставить(24, "311222");
СтруктураКодов.Вставить(25, "321122");
СтруктураКодов.Вставить(26, "321221");
СтруктураКодов.Вставить(27, "312212");
СтруктураКодов.Вставить(28, "322112");
СтруктураКодов.Вставить(29, "322211");
СтруктураКодов.Вставить(30, "212123");
СтруктураКодов.Вставить(31, "212321");
СтруктураКодов.Вставить(32, "232121");
СтруктураКодов.Вставить(33, "111323");
СтруктураКодов.Вставить(34, "131123");
СтруктураКодов.Вставить(35, "131321");
СтруктураКодов.Вставить(36, "112313");
СтруктураКодов.Вставить(37, "132113");
СтруктураКодов.Вставить(38, "132311");
СтруктураКодов.Вставить(39, "211313");
СтруктураКодов.Вставить(40, "231113");
СтруктураКодов.Вставить(41, "231311");
СтруктураКодов.Вставить(42, "112133");
СтруктураКодов.Вставить(43, "112331");
СтруктураКодов.Вставить(44, "132131");
СтруктураКодов.Вставить(45, "113123");
СтруктураКодов.Вставить(46, "113321");
СтруктураКодов.Вставить(47, "133121");
СтруктураКодов.Вставить(48, "313121");
СтруктураКодов.Вставить(49, "211331");
СтруктураКодов.Вставить(50, "231131");
СтруктураКодов.Вставить(51, "213113");
СтруктураКодов.Вставить(52, "213311");
СтруктураКодов.Вставить(53, "213131");
СтруктураКодов.Вставить(54, "311123");
СтруктураКодов.Вставить(55, "311321");
СтруктураКодов.Вставить(56, "331121");
СтруктураКодов.Вставить(57, "312113");
СтруктураКодов.Вставить(58, "312311");
СтруктураКодов.Вставить(59, "332111");
СтруктураКодов.Вставить(60, "314111");
СтруктураКодов.Вставить(61, "221411");
СтруктураКодов.Вставить(62, "431111");
СтруктураКодов.Вставить(63, "111224");
СтруктураКодов.Вставить(64, "111422");
СтруктураКодов.Вставить(65, "121124");
СтруктураКодов.Вставить(66, "121421");
СтруктураКодов.Вставить(67, "141122");
СтруктураКодов.Вставить(68, "141221");
СтруктураКодов.Вставить(69, "112214");
СтруктураКодов.Вставить(70, "112412");
СтруктураКодов.Вставить(71, "122114");
СтруктураКодов.Вставить(72, "122411");
СтруктураКодов.Вставить(73, "142112");
СтруктураКодов.Вставить(74, "142211");
СтруктураКодов.Вставить(75, "241211");
СтруктураКодов.Вставить(76, "221114");
СтруктураКодов.Вставить(77, "413111");
СтруктураКодов.Вставить(78, "241112");
СтруктураКодов.Вставить(79, "134111");
СтруктураКодов.Вставить(80, "111242");
СтруктураКодов.Вставить(81, "121142");
СтруктураКодов.Вставить(82, "121241");
СтруктураКодов.Вставить(83, "114212");
СтруктураКодов.Вставить(84, "124112");
СтруктураКодов.Вставить(85, "124211");
СтруктураКодов.Вставить(86, "411212");
СтруктураКодов.Вставить(87, "421112");
СтруктураКодов.Вставить(88, "421211");
СтруктураКодов.Вставить(89, "212141");
СтруктураКодов.Вставить(90, "214121");
СтруктураКодов.Вставить(91, "412121");
СтруктураКодов.Вставить(92, "111143");
СтруктураКодов.Вставить(93, "111341");
СтруктураКодов.Вставить(94, "131141");
СтруктураКодов.Вставить(95, "114113");
СтруктураКодов.Вставить(96, "114311");
СтруктураКодов.Вставить(97, "411113");
СтруктураКодов.Вставить(98, "411311");
СтруктураКодов.Вставить(99, "113141");
СтруктураКодов.Вставить(100, "114131");
СтруктураКодов.Вставить(101, "311141");
СтруктураКодов.Вставить(102, "411131");
СтруктураКодов.Вставить(103, "211412");
СтруктураКодов.Вставить(104, "211214");
СтруктураКодов.Вставить(105, "211232");
СтруктураКодов.Вставить(106, "2331112");
