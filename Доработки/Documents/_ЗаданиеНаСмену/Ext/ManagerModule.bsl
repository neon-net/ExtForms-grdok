﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов


// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт


КонецПроцедуры

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании) Экспорт
	 
	Если ПравоДоступа("Добавление", Метаданные.Документы._ЗаданиеНаСмену) Тогда
		
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы._ЗаданиеНаСмену.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ВводНаОсновании.ПредставлениеОбъекта(Метаданные.Документы._ЗаданиеНаСмену);
		КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;

	Возврат Неопределено;
	
КонецФункции

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт

КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ЗаданиеНаСмену";
	КомандаПечати.Представление = НСтр("ru = 'Задание на смену'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Процедура печати документа.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗаданиеНаСмену") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ЗаданиеНаСмену",
			НСтр("ru = 'Задание на смену'"),
			СформироватьПечатнуюФормуЗаданиеНаСмену(МассивОбъектов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуЗаданиеНаСмену(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаданиеНаСмену_ЗаданиеНаСмену";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ._ЗаданиеНаСмену.ПФ_MXL_ЗаданиеНаСмену");
	
	ЗапросПоДокументам = Новый Запрос;
	ЗапросПоДокументам.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	ЗапросПоДокументам.Текст =
	"ВЫБРАТЬ
	|	Док.Дата КАК ДатаФормирования,
	|	Док.ДатаСмены КАК Дата,
	|	Док.Номер КАК Номер,
	|	"""" КАК Префикс,
	|	Док.Подразделение,
	|	Док.Смена,
	|	Док.Бригада.Родитель КАК Бригада,
	|	Док.Комментарий,
	|	Док.Ссылка,
	|	Док.Продукция.(
	|		НомерСтроки КАК НомерСтроки,
	|		Номенклатура,
	|		Характеристика,
	|		Назначение,
	|		КоличествоПлан,
	|		КоличествоФакт,
	|		Количество,
	|		КоличествоОстаток,
	|		КоличествоЛистов,
	|		КоличествоОстатокЛистов
	|	)
	|ИЗ
	|	Документ._ЗаданиеНаСмену КАК Док
	|ГДЕ
	|	Док.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номер,
	|	НомерСтроки";
	
	РеквизитыДокумента = Новый Структура("Номер, Дата, Префикс");
	
	ПервыйДокумент = Истина;
	ВыборкаДокументы = ЗапросПоДокументам.Выполнить().Выбрать();
	Пока ВыборкаДокументы.Следующий() Цикл
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		// Вывод заголовка.
		ЗаполнитьЗначенияСвойств(РеквизитыДокумента, ВыборкаДокументы);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(РеквизитыДокумента, ВыборкаДокументы.Ссылка.Метаданные().Представление());
		ОбластьМакета.Параметры.Заполнить(ВыборкаДокументы);
		ТабДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
		ТабДокумент.Вывести(ОбластьМакета);
		
		ИтогоКоличество       = 0;
		ИтогоКоличествоЛистов = 0;
		НомерСтроки = 0;
		
		ВыборкаПоСтрокам = ВыборкаДокументы.Продукция.Выбрать();
		Пока ВыборкаПоСтрокам.Следующий() Цикл
			
			Если ВыборкаПоСтрокам.Количество = 0 Тогда
				Продолжить;
			КонецЕсли;	
			
			НомерСтроки = НомерСтроки + 1;
			ИтогоКоличество       = ИтогоКоличество + ВыборкаПоСтрокам.Количество;
			ИтогоКоличествоЛистов = ИтогоКоличествоЛистов + ВыборкаПоСтрокам.КоличествоЛистов;
			
			Продукция = Строка(ВыборкаПоСтрокам.Номенклатура) + " " + Строка(ВыборкаПоСтрокам.Характеристика);
			Если ЗначениеЗаполнено(ВыборкаПоСтрокам.Назначение) Тогда
				Продукция = Продукция + Символы.ПС + Строка(ВыборкаПоСтрокам.Назначение);
			КонецЕсли;	
			
			ОбластьМакета = Макет.ПолучитьОбласть("Строка");
			ОбластьМакета.Параметры.Заполнить(ВыборкаПоСтрокам);
			ОбластьМакета.Параметры.НомерСтроки = НомерСтроки;
			ОбластьМакета.Параметры.Продукция   = Продукция;
			
			ТабДокумент.Вывести(ОбластьМакета);
			
		КонецЦикла;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Итоги");
		ОбластьМакета.Параметры.Количество       = ИтогоКоличество;
		ОбластьМакета.Параметры.КоличествоЛистов = ИтогоКоличествоЛистов;
		
		ТабДокумент.Вывести(ОбластьМакета);
			
	КонецЦикла;	
		
	ТабДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабДокумент;
	
КонецФункции	

#КонецОбласти

#КонецЕсли
