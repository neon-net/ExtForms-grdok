﻿
&НаКлиенте
Процедура СоздатьРоль(Команда)
	СоздатьРольНаСервере();
КонецПроцедуры

&НаСервере
Процедура СоздатьРольНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Имя",      Имя);
	Запрос.Параметры.Вставить("Родитель", Родитель);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Спр.Ссылка
	|ИЗ
	|	Справочник.ИдентификаторыОбъектовМетаданных КАК Спр
	|ГДЕ
	|	Спр.Имя = &Имя
	|	И Спр.Родитель = &Родитель";
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		Сообщить("Роль уже в справочнике");
		Возврат;
	КонецЕсли;	
	
	ОбъектМетаданных = Метаданные.Роли[Имя];
	
	СпрОбъект = Справочники.ИдентификаторыОбъектовМетаданных.СоздатьЭлемент();
	СпрОбъект.Имя      = Имя;
	СпрОбъект.Родитель = Родитель;
	СпрОбъект.ПолноеИмя = "Роль."  + Имя;
	СпрОбъект.Синоним   = ОбъектМетаданных.Представление();
	СпрОбъект.Наименование = СпрОбъект.Синоним + " (Роль)";
	СпрОбъект.ПолныйСиноним = "Роль. " + СпрОбъект.Синоним;
	СпрОбъект.БезДанных = Истина;
	СпрОбъект.ОбменДанными.Загрузка = Истина;
	СпрОбъект.Записать();
	
КонецПроцедуры
