﻿// Сервисная экспортная функция. Вызывается в основной программе при регистрации обработки в информационной базе
// Возвращает структуру с параметрами регистрации
//
// Возвращаемое значение:
//		Структура с полями:
//			Вид - строка, вид обработки, один из возможных: "ДополнительнаяОбработка", "ДополнительныйОтчет", 
//					"ЗаполнениеОбъекта", "Отчет", "ПечатнаяФорма", "СозданиеСвязанныхОбъектов"
//			Назначение - Массив строк имен объектов метаданных в формате: 
//					<ИмяКлассаОбъектаМетаданного>.[ * | <ИмяОбъектаМетаданных>]. 
//					Например, "Документ.СчетЗаказ" или "Справочник.*". Параметр имеет смысл только для назначаемых обработок, для глобальных может не задаваться.
//			Наименование - строка - Наименование обработки, которым будет заполнено наименование элемента справочника по умолчанию.
//			Информация  - строка - Краткая информация или описание по обработке.
//			Версия - строка - Версия обработки в формате “<старший номер>.<младший номер>” используется при загрузке обработок в информационную базу.
//			БезопасныйРежим - булево - Принимает значение Истина или Ложь, в зависимости от того, требуется ли устанавливать или отключать безопасный режим 
//							исполнения обработок. Если истина, обработка будет запущена в безопасном режиме. 
//
//
Функция СведенияОВнешнейОбработке() Экспорт
	
	//Инициализируем структуру с параметрами регистрации
	
	//Определяем список объектов, вызывающих обработку
	ОбъектыНазначенияФормы = Новый Массив;
	ОбъектыНазначенияФормы.Добавить("Документ.ЗаказКлиента");
	
	ПараметрыРегистрации = ПолучитьПараметрыРегистрации(ОбъектыНазначенияФормы);
	
	//Определяем команды для печати формы
	
	ТаблицаКоманд = ПолучитьТаблицуКоманд();
	
	ДобавитьКоманду(ТаблицаКоманд,
		"Invoice (ENG)", // Представление команды в пользовательском интерфейсе
		"Инвойс_ENG",	// Уникальный идентификатор команды
		);
	
	ДобавитьКоманду(ТаблицаКоманд,
		"Invoice (RUS)", // Представление команды в пользовательском интерфейсе
		"Инвойс_RUS",	// Уникальный идентификатор команды
		);
	
	ДобавитьКоманду(ТаблицаКоманд,
		"Packing list (ENG)", // Представление команды в пользовательском интерфейсе
		"PackingList_ENG",	  // Уникальный идентификатор команды
		);
	
	ДобавитьКоманду(ТаблицаКоманд,
		"Packing list (RUS)", // Представление команды в пользовательском интерфейсе
		"PackingList_RUS",	  // Уникальный идентификатор команды
		);
	
	ДобавитьКоманду(ТаблицаКоманд,
		"Заявка", // Представление команды в пользовательском интерфейсе
		"Заявка",	// Уникальный идентификатор команды
		);
	
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

// Формирует структуру с параметрами регистрации регистрации обработки в информационной базе
//
// Параметры:
//	ОбъектыНазначенияФормы - Массив - Массив строк имен объектов метаданных в формате: 
//					<ИмяКлассаОбъектаМетаданного>.[ * | <ИмяОбъектаМетаданных>]. 
//					или строка с именем объекта метаданных 
//	НаименованиеОбработки - строка - Наименование обработки, которым будет заполнено наименование элемента справочника по умолчанию.
//							Необязательно, по умолчанию синоним или представление объекта
//	Информация  - строка - Краткая информация или описание обработки.
//							Необязательно, по умолчанию комментарий объекта
//	Версия - строка - Версия обработки в формате “<старший номер>.<младший номер>” используется при загрузке обработок в информационную базу.
//
//
// Возвращаемое значение:
//		Структура
//
Функция ПолучитьПараметрыРегистрации(ОбъектыНазначенияФормы = Неопределено, НаименованиеОбработки = "", Информация = "")
	
	Если ТипЗнч(ОбъектыНазначенияФормы) = Тип("Строка") Тогда
		ОбъектНазначенияФормы = ОбъектыНазначенияФормы;
		ОбъектыНазначенияФормы = Новый Массив;
		ОбъектыНазначенияФормы.Добавить(ОбъектНазначенияФормы);
	КонецЕсли; 
	
	ПараметрыРегистрации = Новый Структура;
	ПараметрыРегистрации.Вставить("Вид",             "ПечатнаяФорма");
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Истина);
	ПараметрыРегистрации.Вставить("Назначение",      ОбъектыНазначенияФормы);
	
	Если Не ЗначениеЗаполнено(НаименованиеОбработки) Тогда
		НаименованиеОбработки = ЭтотОбъект.Метаданные().Представление();
	КонецЕсли; 
	ПараметрыРегистрации.Вставить("Наименование", НаименованиеОбработки);
	
	ПараметрыРегистрации.Вставить("Информация", Информация);
	ПараметрыРегистрации.Вставить("Версия",     ЭтотОбъект.Метаданные().Комментарий);
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

// Вспомогательная процедура.
//
Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование = "ВызовСерверногоМетода", ПоказыватьОповещение = Ложь, Модификатор = "ПечатьMXL")
	
	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление = Представление;
	НоваяКоманда.Идентификатор = Идентификатор;
	НоваяКоманда.Использование = Использование;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
	НоваяКоманда.Модификатор = Модификатор;
	
КонецПроцедуры

// Формирует таблицу значений с командами печати
//	
// Возвращаемое значение:
//		ТаблицаЗначений
//
Функция ПолучитьТаблицуКоманд()
	
	Команды = Новый ТаблицаЗначений;
	
	//Представление команды в пользовательском интерфейсе
	Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	
	//Уникальный идентификатор команды или имя макета печати
	Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	
	//Способ вызова команды: "ОткрытиеФормы", "ВызовКлиентскогоМетода", "ВызовСерверногоМетода"
	// "ОткрытиеФормы" - применяется только для отчетов и дополнительных отчетов
	// "ВызовКлиентскогоМетода" - вызов процедуры Печать(), определённой в модуле формы обработки
	// "ВызовСерверногоМетода" - вызов процедуры Печать(), определённой в модуле объекта обработки
	Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
	
	//Показывать оповещение.
	//Если Истина, требуется показать оповещение при начале и при завершении работы обработки. 
	//Имеет смысл только при запуске обработки без открытия формы
	Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
	
	//Дополнительный модификатор команды. 
	//Используется для дополнительных обработок печатных форм на основе табличных макетов.
	//Для таких команд должен содержать строку ПечатьMXL
	Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
	
	Возврат Команды;
	
КонецФункции

// Экспортная процедура печати, вызываемая из основной программы
//
// Параметры:
// ВХОДЯЩИЕ:
//  МассивОбъектовНазначения - Массив - список объектов ссылочного типа для печати документа
//                 Как правило, содержит один элемент с ссылкой на вызвавший форму объект (документ, справочник)
//
// ИСХОДЯЩИЕ:
//  КоллекцияПечатныхФорм - ТаблицаЗначений - таблица сформированных табличных документов.
//                 Как правило, содержит одну строку с именем текущей печатной формы
//  ОбъектыПечати - СписокЗначений - список объектов печати. 
//  ПараметрыВывода - Структура - Параметры сформированных табличных документов. Содержит поля:
//  						ДоступнаПечатьПоКомплектно - булево - по умолчанию Ложь
//							ПолучательЭлектронногоПисьма
//							ОтправительЭлектронногоПисьма
//
Процедура Печать(МассивОбъектовНазначения, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Инвойс_ENG") Тогда
		
		ТабличныйДокумент = СформироватьПечатнуюФорму(МассивОбъектовНазначения, ОбъектыПечати, "ПФ_MXL_Инвойс_ENG");
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"Инвойс_ENG",
			"Invoice (ENG)",
			ТабличныйДокумент
			);
		
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Инвойс_RUS") Тогда
		
		ТабличныйДокумент = СформироватьПечатнуюФорму(МассивОбъектовНазначения, ОбъектыПечати, "ПФ_MXL_Инвойс_RUS");
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"Инвойс_RUS",
			"Invoice (RUS)",
			ТабличныйДокумент
			);
		
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "PackingList_ENG") Тогда
		
		ТабличныйДокумент = СформироватьПечатнуюФорму(МассивОбъектовНазначения, ОбъектыПечати, "ПФ_MXL_PackingList_ENG");
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"PackingList_ENG",
			"Packing list (ENG)",
			ТабличныйДокумент
			);
		
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "PackingList_RUS") Тогда
		
		ТабличныйДокумент = СформироватьПечатнуюФорму(МассивОбъектовНазначения, ОбъектыПечати, "ПФ_MXL_PackingList_RUS");
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"PackingList_RUS",
			"Packing list (RUS)",
			ТабличныйДокумент
			);
		
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Заявка") Тогда
		
		ТабличныйДокумент = СформироватьПечатнуюФорму(МассивОбъектовНазначения, ОбъектыПечати, "ПФ_MXL_Заявка");
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"Заявка",
			"Заявка",
			ТабличныйДокумент
			);
		
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПечатнуюФорму(МассивОбъектов, ОбъектыПечати, ИмяМакета)
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.АвтоМасштаб			= Истина;
	ТабДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТабДокумент.ИмяПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_" + ИмяМакета;

	Макет = ПолучитьМакет(ИмяМакета);	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Док.Ссылка,
	|	Док.Дата,
	|	Док.Номер,
	|	Док.Организация,
	|	Док.Контрагент,
	|	Док.Договор,
	|	Док.БанковскийСчет КАК СчетОрганизации,
	|	Док.ЖелаемаяДатаОтгрузки КАК ЖелаемаяДатаОтгрузки,
	|	Док.ДатаОтгрузки КАК ДатаОтгрузки,
	|	Док.Валюта,
	|	Док.Грузополучатель,
	|	Док.ГрафикОплаты
	|ИЗ
	|	Документ.ЗаказКлиента КАК Док
	|ГДЕ
	|	Док.Ссылка В(&МассивОбъектов)";
	
	Шапка = Запрос.Выполнить().Выбрать();
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДокТовары.Номенклатура,
	|	ДокТовары.Характеристика,
	|	ДокТовары.Количество,
	|	ДокТовары._КоличествоМест КАК КоличествоМест,
	|	ЕСТЬNULL(ДокТовары._ЕдиницаМест.Вес, 0) КАК ЕдиницаМестВес,
	|	ЕСТЬNULL(ДокТовары.Номенклатура.ВесЧислитель, 0) КАК ЕдиницаВес,
	|	ДокТовары.Цена,
	|	ДокТовары.Сумма,
	|	ДокТовары.СтавкаНДС,
	|	ДокТовары.СуммаНДС,
	|	ДокТовары.СуммаСНДС,
	|	ДокТовары.Ссылка КАК Ссылка,
	|	ДокТовары.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	Документ.ЗаказКлиента.Товары КАК ДокТовары
	|ГДЕ
	|	ДокТовары.Ссылка В (&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки
	|ИТОГИ ПО
	|	Ссылка";
	
	ВыборкаТовары = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ОбластьШапка   = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока  = Макет.ПолучитьОбласть("Строка");
	ОбластьИтоги   = Макет.ПолучитьОбласть("Итоги");
	ОбластьПодвал  = Макет.ПолучитьОбласть("Подвал");
	ОбластьПодписи = Макет.ПолучитьОбласть("Подписи");
	
	
	ШаблонБанк = 
	"Beneficiary Bank: [СчетБанк]. [СчетБанкAddress].
	|Intermediary Bank: [СчетКорБанк], [СчетКорБанкАдрес].
	|SWIFT CODE: [СчетКорБанкSWIFT], [СчетБанк]
	|Correspondent account number: [СчетКорСчет],
	|Transit account: [СчетНомер].
	|Beneficiary’s account: [СчетНомер], Beneficiary’s name: [ОрганизацияEN].";
	
	ПервыйДокумент = Истина;
	Пока Шапка.Следующий() Цикл
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		ОрганизацияКИ = _ОбщегоНазначенияДоп.ПолучитьКИ(Шапка.Организация);
		
		ДанныеШапки = Новый Структура;
		ДанныеШапки.Вставить("Дата",         Шапка.Дата);
		ДанныеШапки.Вставить("Номер",        Шапка.Номер);
		ДанныеШапки.Вставить("ДатаОтгрузки", Шапка.ДатаОтгрузки);
		ДанныеШапки.Вставить("Валюта",       Шапка.Валюта);
		
		ДанныеШапки.Вставить("УсловияДоставки",   _ОбщегоНазначенияДоп.ПолучитьДопРеквизит(Шапка.Ссылка, "Условие доставки Инкотермс"));
		
		ДанныеШапки.Вставить("Организация",       ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Шапка.Организация, "НаименованиеПолное"));
		ДанныеШапки.Вставить("ОрганизацияАдрес",  ОрганизацияКИ["Юридический адрес"]);
		
		ДанныеШапки.Вставить("ОрганизацияEN",      _ОбщегоНазначенияДоп.ПолучитьДопРеквизит(Шапка.Организация, "Наименование ENG"));
		ДанныеШапки.Вставить("ОрганизацияАдресEN", ОрганизацияКИ["Адрес ENG"]);
		ДанныеШапки.Вставить("ОрганизацияТелефон", ОрганизацияКИ["Телефон"]);
		ДанныеШапки.Вставить("ОрганизацияФакс",    ОрганизацияКИ["Факс"]);
		
		ДанныеШапки.Вставить("СчетSWIFT",                      СокрЛП(Шапка.СчетОрганизации.СВИФТБанка));
		ДанныеШапки.Вставить("AccountWithCorrespondentBank",   Шапка.СчетОрганизации.СчетВБанкеДляРасчетов);
		ДанныеШапки.Вставить("СчетБанк",                       Шапка.СчетОрганизации.НаименованиеБанка);
		ДанныеШапки.Вставить("СчетБанкAddress",                Шапка.СчетОрганизации.АдресБанка);
		ДанныеШапки.Вставить("СчетКорБанкSWIFT",               СокрЛП(Шапка.СчетОрганизации.СВИФТБанкаДляРасчетов));
		ДанныеШапки.Вставить("СчетКорБанк",                    Шапка.СчетОрганизации.НаименованиеБанкаДляРасчетов);
		ДанныеШапки.Вставить("СчетКорБанкАдрес",               Шапка.СчетОрганизации.АдресБанкаДляРасчетов);
		ДанныеШапки.Вставить("СчетКорСчет",                    Шапка.СчетОрганизации.КоррСчетБанка);
		ДанныеШапки.Вставить("СчетBeneficiarysAccount",        _ОбщегоНазначенияДоп.ПолучитьДопРеквизит(Шапка.СчетОрганизации, "Beneficiary’s account"));
		ДанныеШапки.Вставить("СчетНомер",                      Шапка.СчетОрганизации.НомерСчета);
		
		ДанныеШапки.Вставить("ОрганизацияБанк",                _ОбщегоНазначенияДоп.ЗаполнитьПоШаблону(ШаблонБанк, ДанныеШапки));
		ДанныеШапки.Вставить("ОрганизацияБанкEN",              _ОбщегоНазначенияДоп.ЗаполнитьПоШаблону(ШаблонБанк, ДанныеШапки));
		
		ЗаполнитьПараметрыКонтрагента(ДанныеШапки, Шапка.Контрагент, "Контрагент");
		
		Если ЗначениеЗаполнено(Шапка.Грузополучатель) Тогда
			Грузополучатель = Шапка.Грузополучатель;
		Иначе
			Грузополучатель = Шапка.Контрагент;
		КонецЕсли;	
		
		ЗаполнитьПараметрыКонтрагента(ДанныеШапки, Грузополучатель, "Грузополучатель");
		
		Если НЕ ЗначениеЗаполнено(Шапка.Договор) Тогда
			ДанныеШапки.Вставить("ДоговорНомер", "No contract");
			ДанныеШапки.Вставить("ДоговорДата",  "");
		Иначе
			
			РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Шапка.Договор, "Номер, Дата");
			ДанныеШапки.Вставить("ДоговорНомер", СокрЛП(РеквизитыДоговора.Номер));
			ДанныеШапки.Вставить("ДоговорДата",  РеквизитыДоговора.Дата);
			
		КонецЕсли;	
		
		ДанныеШапки.Вставить("УсловияОплаты",   ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Шапка.ГрафикОплаты, "Наименование"));
		ДанныеШапки.Вставить("УсловияОплатыEN", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Шапка.ГрафикОплаты, "_НаименованиеENG"));
		
		ОбластьШапка.Параметры.Заполнить(ДанныеШапки);
		ТабДокумент.Вывести(ОбластьШапка);
		
		Итоги = Новый Структура;
		Итоги.Вставить("Количество", 0);
		Итоги.Вставить("Сумма",      0);
		Итоги.Вставить("КолвоМест",  0);
		Итоги.Вставить("Нетто",      0);
		Итоги.Вставить("Брутто",     0);
		
		Если ВыборкаТовары.НайтиСледующий(Новый Структура("Ссылка", Шапка.Ссылка)) Тогда
			
			ВыборкаДетали = ВыборкаТовары.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаДетали.Следующий() Цикл
				
				ДанныеСтроки = Новый Структура;
				ДанныеСтроки.Вставить("Артикул",    ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВыборкаДетали.Номенклатура, "Артикул"));
				ДанныеСтроки.Вставить("Цена",       ВыборкаДетали.Цена);
				ДанныеСтроки.Вставить("Количество", ВыборкаДетали.Количество);
				ДанныеСтроки.Вставить("Сумма",      ВыборкаДетали.Сумма);
				
				ДанныеСтроки.Вставить("КолвоМест", ВыборкаДетали.КоличествоМест);
				ДанныеСтроки.Вставить("Нетто",     ВыборкаДетали.Количество * ВыборкаДетали.ЕдиницаВес);
				ДанныеСтроки.Вставить("Брутто",    ВыборкаДетали.КоличествоМест * ВыборкаДетали.ЕдиницаМестВес + ДанныеСтроки.Нетто);
				
				ДанныеСтроки.Вставить("Номенклатура",    СокрЛП(_ОбщегоНазначенияДоп.ПолучитьДопРеквизит(ВыборкаДетали.Номенклатура, "Описание товара RUS")));
				ДанныеСтроки.Вставить("НоменклатураEN",  СокрЛП(_ОбщегоНазначенияДоп.ПолучитьДопРеквизит(ВыборкаДетали.Номенклатура, "Описание товара ENG")));
				ДанныеСтроки.Вставить("Характеристика",  ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВыборкаДетали.Характеристика, "Наименование"));
				
				ДанныеСтроки.Вставить("НоменклатураХарактеристика",   ДанныеСтроки.Номенклатура   + " (" + ДанныеСтроки.Характеристика + ")");
				ДанныеСтроки.Вставить("НоменклатураХарактеристикаEN", ДанныеСтроки.НоменклатураEN + " (" + ДанныеСтроки.Характеристика + ")");
				
				ОбластьСтрока.Параметры.Заполнить(ДанныеСтроки);
				ТабДокумент.Вывести(ОбластьСтрока);
				
				РассчитатьИтоги(Итоги, ДанныеСтроки);
				
			КонецЦикла;	
			
		КонецЕсли;	
		
		ОбластьИтоги.Параметры.Заполнить(Итоги);
		ТабДокумент.Вывести(ОбластьИтоги);
		
		ОбластьПодвал.Параметры.Заполнить(ДанныеШапки);
		ТабДокумент.Вывести(ОбластьПодвал);
		
		ТабДокумент.Вывести(ОбластьПодписи);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции	

Функция РассчитатьИтоги(Итоги, ДанныеСтроки)
	
	Для каждого КлючИЗначение из Итоги Цикл
		Итоги[КлючИЗначение.Ключ] = КлючИЗначение.Значение + ДанныеСтроки[КлючИЗначение.Ключ];
	КонецЦикла;	
	
КонецФункции

Процедура ЗаполнитьПараметрыКонтрагента(ДанныеШапки, Контрагент, ИмяРеквизита)
	
	РеквизитыКонтрагента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Контрагент, "НаименованиеПолное, РегистрационныйНомер");
	
	ДанныеШапки.Вставить(ИмяРеквизита,              РеквизитыКонтрагента.НаименованиеПолное);
	ДанныеШапки.Вставить(ИмяРеквизита + "РегНомер", РеквизитыКонтрагента.РегистрационныйНомер);
	
	КонтрагентКИ = _ОбщегоНазначенияДоп.ПолучитьКИ(Контрагент);
	ДанныеШапки.Вставить(ИмяРеквизита + "Адрес",   КонтрагентКИ["Юридический адрес"]);
	ДанныеШапки.Вставить(ИмяРеквизита + "Телефон", КонтрагентКИ["Телефон"]);
	ДанныеШапки.Вставить(ИмяРеквизита + "Факс",    КонтрагентКИ["Факс"]);
	
	КонтрагентТекст   = ДанныеШапки[ИмяРеквизита];
	КонтрагентТекстEN = ДанныеШапки[ИмяРеквизита];
	
	Если ЗначениеЗаполнено(РеквизитыКонтрагента.РегистрационныйНомер) Тогда
		КонтрагентТекст   = КонтрагентТекст   + ". Рег. номер: "                 + РеквизитыКонтрагента.РегистрационныйНомер;
		КонтрагентТекстEN = КонтрагентТекстEN + ". Commercial Registration No: " + РеквизитыКонтрагента.РегистрационныйНомер;
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ДанныеШапки[ИмяРеквизита + "Адрес"]) Тогда
		КонтрагентТекст   = КонтрагентТекст   + ". Адрес: "   + ДанныеШапки[ИмяРеквизита + "Адрес"];
		КонтрагентТекстEN = КонтрагентТекстEN + ". Address: " + ДанныеШапки[ИмяРеквизита + "Адрес"];
	КонецЕсли;	
	
	ДанныеШапки.Вставить(ИмяРеквизита + "Текст",   КонтрагентТекст);
	ДанныеШапки.Вставить(ИмяРеквизита + "ТекстEN", КонтрагентТекстEN);
		
КонецПроцедуры
