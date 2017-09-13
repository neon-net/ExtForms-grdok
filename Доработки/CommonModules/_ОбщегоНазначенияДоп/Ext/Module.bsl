﻿// Вызывается из
// ПартионныйУчет.ТекстДанныеПоПродукции
Функция ТекстЗапросаОтработанныеМЛ() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокВыходныеИзделия.Ссылка.Распоряжение КАК Распоряжение,
	|	ДокВыходныеИзделия.Ссылка.КодСтроки КАК КодСтроки
	|ПОМЕСТИТЬ ОтработанныеМЛ
	|ИЗ
	|	Документ.МаршрутныйЛистПроизводства.ВыходныеИзделия КАК ДокВыходныеИзделия
	|ГДЕ
	|	ДокВыходныеИзделия.Ссылка.Дата МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|	И ДокВыходныеИзделия.Ссылка.Проведен
	|	И ДокВыходныеИзделия.Ссылка.Организация В (&МассивОрганизаций)
	|	И ДокВыходныеИзделия.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыМаршрутныхЛистовПроизводства.Выполнен)
	|	И ДокВыходныеИзделия.КоличествоФакт <> 0
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции	

Функция ПолучитьДопРеквизит(Знач Объект, Знач Свойство) Экспорт

	Если НЕ (ЗначениеЗаполнено(Объект)
			И ЗначениеЗаполнено(Свойство)) Тогда
		Возврат "";
	КонецЕсли; 
	
	Запрос = Новый ПостроительЗапроса;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДопРеквизит.Значение
	|ИЗ
	|	Справочник.Партнеры.ДополнительныеРеквизиты КАК ДопРеквизит
	|ГДЕ
	|	ДопРеквизит.Ссылка = &Объект
	|{ГДЕ
	|	ДопРеквизит.Свойство.*}";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "Справочник.Партнеры", Объект.Метаданные().ПолноеИмя());
	
	Запрос.Параметры.Вставить("Объект", Объект);
	
	Если ТипЗнч(Свойство) = Тип("Строка") Тогда
		ЭлементОтбора = Запрос.Отбор.Добавить("Свойство.Заголовок");
	Иначе	
		ЭлементОтбора = Запрос.Отбор.Добавить("Свойство");
	КонецЕсли;	
	ЭлементОтбора.Установить(Свойство, Истина);
	
	Запрос.Выполнить();
	Таблица = Запрос.Результат.Выгрузить();
	Если Таблица.Количество() = 0 Тогда
		Возврат "";
	Иначе
		Возврат Таблица[0].Значение;
	КонецЕсли; 
	
КонецФункции // ПолучитьДопРеквизит()

Функция ПолучитьДопСведение(Знач Объект, Знач Свойство) Экспорт

	Если НЕ (ЗначениеЗаполнено(Объект)
			И ЗначениеЗаполнено(Свойство)) Тогда
		Возврат "";
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДопРеквизит.Значение
	|ИЗ
	|	РегистрСведений.ДополнительныеСведения КАК ДопРеквизит
	|ГДЕ
	|	ДопРеквизит.Объект = &Объект
	|	И ДопРеквизит.Свойство В(&Свойство)";
	
	Запрос.УстановитьПараметр("Свойство", Свойство);
	Запрос.УстановитьПараметр("Объект",   Объект);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Если Таблица.Количество() = 0 Тогда
		Возврат "";
	Иначе
		Возврат Таблица[0].Значение;
	КонецЕсли; 
	
КонецФункции // ПолучитьДанныеКонтактнойИнформации()

Функция ПолучитьДопРеквизитИзСписка(Знач Объект, Знач ЗначенияСвойств, Знач МассивСвойств) Экспорт

	Значение = Неопределено;
	Если ТипЗнч(МассивСвойств) <> Тип("Массив") Тогда
		
		НовыйМассивСвойств = Новый Массив;
		НовыйМассивСвойств.Добавить(МассивСвойств);
		
		
		МассивСвойств = НовыйМассивСвойств;
		
	КонецЕсли;	
	
	Если ЗначенияСвойств = Неопределено Тогда
		
		ЗначенияСвойств = Новый Соответствие;
		Для каждого Свойство из МассивСвойств Цикл
			
			Значение = ПолучитьДопРеквизит(Объект, Свойство);
			Если ЗначениеЗаполнено(Значение) Тогда
				Возврат Значение;
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе	
		
		Для каждого Свойство из МассивСвойств Цикл
			
			Значение = ЗначенияСвойств[Свойство];
			Если ЗначениеЗаполнено(Значение) Тогда
				Возврат Значение;
			КонецЕсли;	
			
		КонецЦикла;
		
	КонецЕсли;	
	
	Возврат Значение; 
	
КонецФункции // ПолучитьДопРеквизит()

Функция ПолучитьЗначенияСвойств(Знач Объект) Экспорт

	Если НЕ ЗначениеЗаполнено(Объект) Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДопРеквизит.Значение,
	|	ДопРеквизит.Свойство.Заголовок КАК Свойство
	|ИЗ
	|	Справочник.Партнеры.ДополнительныеРеквизиты КАК ДопРеквизит
	|ГДЕ
	|	ДопРеквизит.Ссылка = &Объект";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "Справочник.Партнеры", Объект.Метаданные().ПолноеИмя());
	
	Запрос.Параметры.Вставить("Объект", Объект);
	
	Результат = Новый Соответствие;
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Для каждого СтрокаТЗ из Таблица Цикл
		Результат.Вставить(СтрокаТЗ.Свойство, СтрокаТЗ.Значение);
	КонецЦикла;	
	
	Возврат Результат;
	
Конецфункции	


Функция ПолучитьКоличествоМест(Характеристика, Количество) Экспорт
	
	ОбъемПачки = _ОбщегоНазначенияДоп.ПолучитьДопРеквизит(Характеристика, "Объем пачки");
	Если НЕ ЗначениеЗаполнено(ОбъемПачки) Тогда
		Возврат 0;
	КонецЕсли;	
		
	// Округляем ввверх
	Возврат Окр(Количество / ОбъемПачки + 0.49, 0);
	
КонецФункции

Функция ПолучитьКоличествоПоКоличествуМест(Характеристика, КоличествоМест) Экспорт
	
	ОбъемПачки = _ОбщегоНазначенияДоп.ПолучитьДопРеквизит(Характеристика, "Объем пачки");
	Если НЕ ЗначениеЗаполнено(ОбъемПачки) Тогда
		Возврат 0;
	КонецЕсли;	
	
	Возврат Окр(КоличествоМест * ОбъемПачки, 3);
	
КонецФункции

Функция ПолучитьОбъемПачки(Длина, Ширина, Толщина, КоличествоЛистов) Экспорт

	Если НЕ ЗначениеЗаполнено(Длина)
		ИЛИ НЕ ЗначениеЗаполнено(Ширина)
		ИЛИ НЕ ЗначениеЗаполнено(Толщина)
		ИЛИ НЕ ЗначениеЗаполнено(КоличествоЛистов) Тогда
		
		Возврат 0;
		
	КонецЕсли;	
	
	Возврат  Окр((Длина/1000) * (Ширина/1000) * (Толщина/1000) * КоличествоЛистов, 3);
	
КонецФункции // ПолучитьОбъемПачки()

Функция ПолучитьКоличествоЛистов(Характеристика, Количество) Экспорт
	
	_Длина   = _ХарактеристикиНоменклатуры.ПолучитьДлину(Характеристика);
	_Ширина  = _ХарактеристикиНоменклатуры.ПолучитьШирину(Характеристика);
	_Толщина = _ХарактеристикиНоменклатуры.ПолучитьТолщину(Характеристика);
	
	Если _Длина <> 0
		И _Ширина <> 0
		И _Толщина <> 0 Тогда
		
		Возврат Окр(Количество / ((_Длина/1000) * (_Ширина/1000) * (_Толщина/1000)), 0);
		
	КонецЕсли;
	
	Возврат 0;
	
КонецФункции	

Функция ПолучитьКоличествоПоКоличествуЛистов(Характеристика, КоличествоЛистов, ЗначенияСвойств = Неопределено) Экспорт
	
	_Длина   = _ХарактеристикиНоменклатуры.ПолучитьДлину(Характеристика, ЗначенияСвойств);
	_Ширина  = _ХарактеристикиНоменклатуры.ПолучитьШирину(Характеристика, ЗначенияСвойств);
	_Толщина = _ХарактеристикиНоменклатуры.ПолучитьТолщину(Характеристика, ЗначенияСвойств);
	
	Если _Длина <> 0
		И _Ширина <> 0
		И _Толщина <> 0 Тогда
		
		Возврат Окр(КоличествоЛистов * ((_Длина/1000) * (_Ширина/1000) * (_Толщина/1000)), 3);
		
	КонецЕсли;
	
	Возврат 0;
	
КонецФункции	

Функция ПолучитьКИ(Объект, ВидКИ = Неопределено) Экспорт
	
	Запрос = Новый ПостроительЗапроса;
	Запрос.Параметры.Вставить("Ссылка", Объект);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпрКИ.Вид.Наименование КАК Вид,
	|	СпрКИ.Представление
	|ИЗ
	|	Справочник.Организации.КонтактнаяИнформация КАК СпрКИ
	|ГДЕ
	|	СпрКИ.Ссылка = &Ссылка
	|{ГДЕ
	|	СпрКИ.Вид.*}";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, ".Организации.", "." + Объект.Метаданные().Имя + ".");
	
	Если ВидКИ <> Неопределено Тогда
		
		ЭлементОтбора = Запрос.Отбор.Добавить("Вид", ВидКИ);
		ЭлементОтбора.Установить(ВидКИ, Истина);
		
	КонецЕсли;	
	
	Запрос.Выполнить();
	Если ВидКИ <> Неопределено Тогда
		
		Если Запрос.Результат.Пустой() Тогда
			Возврат "";
		Иначе	
			Возврат СокрЛП(Запрос.Результат.Выгрузить()[0].Представление);
		КонецЕсли;
		
	Иначе	
		
		Соответствие = Новый Соответствие;
		Таблица = Запрос.Результат.Выгрузить();
		Для каждого СтрокаТЗ из Таблица Цикл
			Соответствие.Вставить(СокрЛП(СтрокаТЗ.Вид), СокрЛП(СтрокаТЗ.Представление));
		КонецЦикла;	
		
		Возврат Соответствие;
		
	КонецЕсли;	
		
КонецФункции

Функция ЗаполнитьПоШаблону(Шаблон, Параметры) Экспорт
	
	Стр = Шаблон;
	Для Каждого КлючИЗначение из Параметры Цикл
		
		Стр = СтрЗаменить(Стр, "[" + КлючИЗначение.Ключ + "]", КлючИЗначение.Значение);
		
	КонецЦикла;	
	
	Возврат Стр;
	
КонецФункции

Функция Перевести(Стр) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Рег.НаименованиеENG КАК Наименование
	|ИЗ
	|	РегистрСведений._Переводы КАК Рег
	|ГДЕ
	|	Рег.Наименование = &Наименование";
	
	Запрос.Параметры.Вставить("Наименование", Стр);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Стр;
	Иначе
		Возврат Результат.Выгрузить()[0][0];
	КонецЕсли;	
	
КонецФункции	

Процедура ДобавитьКолонкуЕстьФайлы(Форма, ИмяРеквизитаСписок, ИмяТаблицы, ВставитьПередЭлементом, ЭлементСписок = Неопределено) Экспорт
	
	Если ЭлементСписок = Неопределено Тогда
		ЭлементСписок = Форма.Элементы[ИмяРеквизитаСписок];
	КонецЕсли;	
	
	Список = Форма[ИмяРеквизитаСписок]; 
	ТекстЗапроса = Список.ТекстЗапроса;
	
	СхемаЗапроса = Новый СхемаЗапроса;
    СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапроса);	
	
	ЗапросВыбораСхемыЗапроса = СхемаЗапроса.ПакетЗапросов[СхемаЗапроса.ПакетЗапросов.Количество() - 1];
	Оператор = ЗапросВыбораСхемыЗапроса.Операторы[0];
	
	Оператор.Источники.Добавить("РегистрСведений.НаличиеПрисоединенныхФайлов", "НаличиеПрисоединенныхФайлов");
	_ОбработчикиПроведенияСервер.ДобавитьУсловиеСоединения(Оператор, ИмяТаблицы, "НаличиеПрисоединенныхФайлов", ИмяТаблицы + ".Ссылка = НаличиеПрисоединенныхФайлов.ОбъектСФайлами");
	
	ТекстЕстьФайлы =
	"ВЫБОР
	|	КОГДА НаличиеПрисоединенныхФайлов.ЕстьФайлы ЕСТЬ NULL ТОГДА
	|		1
	|	КОГДА НаличиеПрисоединенныхФайлов.ЕстьФайлы ТОГДА
	|		0
	|	ИНАЧЕ
	|		1
	|КОНЕЦ"; 
	_ОбработчикиПроведенияСервер.ДобавитьПолеВЗапрос(ЗапросВыбораСхемыЗапроса, Оператор, "_ЕстьФайлы", ТекстЕстьФайлы);
 
	ТекстЗапроса = СхемаЗапроса.ПолучитьТекстЗапроса();
	Список.ТекстЗапроса = ТекстЗапроса;
	
	Элемент = Форма.Элементы.Вставить("_ЕстьФайлы", Тип("ПолеФормы"), ЭлементСписок, ВставитьПередЭлементом);
    Элемент.Вид         = ВидПоляФормы.ПолеКартинки;
	Элемент.ПутьКДанным = ИмяРеквизитаСписок + "._ЕстьФайлы";
	Элемент.Ширина      = 1;
	Элемент.РастягиватьПоГоризонтали = Ложь;
	Элемент.КартинкаЗначений = БиблиотекаКартинок.Скрепка;
	Элемент.КартинкаШапки    = БиблиотекаКартинок.Скрепка;
	Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	
КонецПроцедуры

Функция вЧисло(Знач Парам) Экспорт
	
	Если ТипЗнч(Парам) = Тип("Число") Тогда
		Возврат Парам;
	КонецЕсли;	
	
	Парам = СтрЗаменить(СокрЛП(Парам), "," , ".");
	Парам = СтрЗаменить(Парам, Символы.НПП, "");
	
	Попытка
		Возврат Число(Парам);
	Исключение
		Возврат 0;
	КонецПопытки;	
	
Конецфункции	

Функция ЕстьNULL(Знач Парам, Знач ЗначениеПоУмолчанию) Экспорт
	
	Возврат ?(ЗначениеЗаполнено(Парам) , Парам, ЗначениеПоУмолчанию);
	
КонецФункции	

Функция Абс(Знач Парам) Экспорт
	
	Возврат ?(Парам > 0, Парам, -Парам);
	
КонецФункции	

Функция ФизлицоУволено(Физлицо) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("ФизическоеЛицо", Физлицо);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Сотрудники.Ссылка
	|ИЗ
	|	Справочник.Сотрудники КАК Сотрудники
	|ГДЕ
	|	Сотрудники.ФизическоеЛицо = &ФизическоеЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Сотрудники.Ссылка
	|ИЗ
	|	Справочник.Сотрудники КАК Сотрудники
	|ГДЕ
	|	НЕ Сотрудники.ВАрхиве
	|	И Сотрудники.ФизическоеЛицо = &ФизическоеЛицо";
	
	Результат = Запрос.ВыполнитьПакет();
	Возврат НЕ Результат[0].Пустой() И Результат[1].Пустой();
	
КонецФункции	

Функция ПолучитьСотрудникаПоФизЛицу(ФизическоеЛицо, Организация, Дата) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("ФизическоеЛицо", ФизическоеЛицо);
	Запрос.Параметры.Вставить("Организация",    Организация);
	Запрос.Параметры.Вставить("Дата",           Дата);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Рег.Сотрудник
	|ИЗ
	|	РегистрСведений.ДанныеДляПодбораСотрудников КАК Рег
	|ГДЕ
	|	Рег.Организация = &Организация
	|	И Рег.ФизическоеЛицо = &ФизическоеЛицо
	|	И Рег.Начало <= &Дата
	|	И (Рег.Окончание >= &Дата
	|			ИЛИ Рег.Окончание = ДАТАВРЕМЯ(1, 1, 1))";
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		Возврат Результат.Выгрузить()[0].Сотрудник;
	КонецЕсли;	
	
КонецФункции	

Функция ПолучитьТабельПоОснованию(Основание) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Основание", Основание);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Док.Ссылка
	|ИЗ
	|	Документ.ТабельУчетаРабочегоВремени КАК Док
	|ГДЕ
	|	Док._Основание = &Основание";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		Возврат Результат.Выгрузить()[0][0];
	КонецЕсли;	
	
КонецФункции
