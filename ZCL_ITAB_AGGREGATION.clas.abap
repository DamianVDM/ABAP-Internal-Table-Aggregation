CLASS zcl_itab_aggregation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES ty_group TYPE c LENGTH 1.
    TYPES: BEGIN OF initial_numbers_type,
             group  TYPE ty_group,
             number TYPE i,
           END OF initial_numbers_type,
           initial_numbers TYPE STANDARD TABLE OF initial_numbers_type WITH NON-UNIQUE KEY group number.

    TYPES: BEGIN OF aggregated_data_type,
             group   TYPE ty_group,
             count   TYPE i,
             sum     TYPE i,
             min     TYPE i,
             max     TYPE i,
             average TYPE f,
           END OF aggregated_data_type,
           aggregated_data TYPE STANDARD TABLE OF aggregated_data_type WITH EMPTY KEY.

    METHODS perform_aggregation
      IMPORTING
        initial_numbers        TYPE initial_numbers
      RETURNING
        VALUE(aggregated_data) TYPE aggregated_data.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_itab_aggregation IMPLEMENTATION.
  METHOD perform_aggregation.
    " Made reference too https://exercism.org/tracks/abap/exercises/itab-aggregation/solutions/muasya
    " Loop through the initial_numbers internal table, and assign reference into new variable intial_number.
    LOOP AT initial_numbers REFERENCE INTO DATA(initial_number)
      " Create a group with identifer based on group type, assign the count size to the group size
      GROUP BY ( key = initial_number->group count = GROUP SIZE )
      ASCENDING
      REFERENCE INTO DATA(group_key). " group key - same as group A or group B

      APPEND INITIAL LINE TO aggregated_data REFERENCE INTO DATA(aggregated_item).
      aggregated_item->group = group_key->key. " assign groups key (A/B/C) to the group
      aggregated_item->count = group_key->count.
      aggregated_item->min = 99999.
      LOOP AT GROUP group_key REFERENCE INTO DATA(group_item).
        aggregated_item->sum = aggregated_item->sum + group_item->number.
        " nmin stands for numeric minium, checks 2 values and sets lowest, same for nmax. Checks if min < number, if so, min = number
        aggregated_item->min = nmin( val1 = aggregated_item->min
                                     val2 = group_item->number ).
        aggregated_item->max = nmax( val1 = aggregated_item->max
                                     val2 = group_item->number ).
      ENDLOOP.
      aggregated_item->average = aggregated_item->sum / aggregated_item->count.
    ENDLOOP.


  ENDMETHOD.

ENDCLASS.
