object DataModule1: TDataModule1
  OldCreateOrder = False
  Height = 448
  Width = 296
  object FDTable1: TFDTable
    Connection = FDConnection1
    Left = 168
    Top = 72
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 128
    Top = 16
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 120
    Top = 144
  end
  object FDSQLiteSecurity1: TFDSQLiteSecurity
    DriverLink = FDPhysSQLiteDriverLink1
    Left = 112
    Top = 208
  end
  object RESTClient1: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'https://jsonplaceholder.typicode.com/photos'
    Params = <>
    RaiseExceptionOn500 = False
    Left = 32
    Top = 40
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 40
    Top = 48
  end
  object RESTResponse1: TRESTResponse
    ContentType = 'application/json'
    Left = 48
    Top = 56
  end
  object RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter
    Active = True
    Dataset = FDMemTable1
    FieldDefs = <>
    Response = RESTResponse1
    NestedElements = True
    Left = 56
    Top = 64
  end
  object FDMemTable1: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'albumId'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'id'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'title'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'url'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'thumbnailUrl'
        DataType = ftWideString
        Size = 255
      end>
    IndexDefs = <>
    IndexFieldNames = 'id'
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 64
    Top = 72
  end
  object FDQueryDelete: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'DELETE FROM Photos')
    Left = 208
    Top = 120
  end
end
