﻿
Процедура ПриСозданииНаСервере_ФормаЭлемента(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Объект = Форма.Объект;
	
	Форма.Элементы.Подразделение.АвтоОтметкаНезаполненного = Истина;
	
	Элемент = Форма.Элементы.Вставить("_ПаспортСделки", Тип("ПолеФормы"), Форма.Элементы.ГруппаОрганизация, );
    Элемент.Вид         = ВидПоляФормы.ПолеВвода;
	Элемент.ПутьКДанным = "Объект._ПаспортСделки";
	Элемент.Ширина      = 34;
	
КонецПроцедуры
