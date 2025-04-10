//
//  Reminder.swift
//  ProjetoIdosos
//
//  Created by Turma02-16 on 02/04/25.
//

import SwiftUI
import UserNotifications

extension Date {

  static func today() -> Date {
      return Date()
  }

  func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.next,
               weekday,
               considerToday: considerToday)
  }

  func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.previous,
               weekday,
               considerToday: considerToday)
  }

  func get(_ direction: SearchDirection,
           _ weekDay: Weekday,
           considerToday consider: Bool = false) -> Date {

    let dayName = weekDay.rawValue

    let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }

    assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")

    let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1

    let calendar = Calendar(identifier: .gregorian)

    if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
      return self
    }

    var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
    nextDateComponent.weekday = searchWeekdayIndex

    let date = calendar.nextDate(after: self,
                                 matching: nextDateComponent,
                                 matchingPolicy: .nextTime,
                                 direction: direction.calendarSearchDirection)

    return date!
  }

}

// MARK: Helper methods
extension Date {
  func getWeekDaysInEnglish() -> [String] {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "en_US_POSIX")
    return calendar.weekdaySymbols
  }

  enum Weekday: String {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
  }

  enum SearchDirection {
    case next
    case previous

    var calendarSearchDirection: Calendar.SearchDirection {
      switch self {
      case .next:
        return .forward
      case .previous:
        return .backward
      }
    }
  }
}

func scheduleNotification(reminder:Reminders) {
    let content = UNMutableNotificationContent()
    content.title = reminder.title
    content.subtitle = reminder.description
    content.sound = UNNotificationSound.default

    if reminder.isRepeatable {
        let days = [
            0:Date.today().next(.sunday),
            1:Date.today().next(.monday),
            2:Date.today().next(.tuesday),
            3:Date.today().next(.wednesday),
            4:Date.today().next(.thursday),
            5:Date.today().next(.friday),
            6:Date.today().next(.saturday)
        ]
        
        for i in 0...6 {
            if reminder.repeatDays[i] {
                let request = UNNotificationRequest(
                    identifier: UUID().uuidString,
                    content: content,
                    trigger: UNCalendarNotificationTrigger(
                        dateMatching: DateComponents(
                            year: Calendar.current.component(
                                .year, from: Date(timeIntervalSince1970: TimeInterval(reminder.datetime))
                            ),
                            month: Calendar.current.component(
                                .month, from: Date(timeIntervalSince1970: TimeInterval(reminder.datetime))
                            ),
                            day: Calendar.current.component(
                                .day, from: days[i]!
                            ),
                            hour: Calendar.current.component(
                                .hour, from: Date(timeIntervalSince1970: TimeInterval(reminder.datetime))
                            ),
                            minute: Calendar.current.component(
                                .minute, from: Date(timeIntervalSince1970: TimeInterval(reminder.datetime))
                            ),
                            second: Calendar.current.component(
                                .second, from: Date(timeIntervalSince1970: TimeInterval(reminder.datetime))
                            )
                        ),
                        repeats: false
                    )
                )

                UNUserNotificationCenter.current().add(request)
            }
        }
    } else {
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: DateComponents(
                year: Calendar.current.component(
                    .year, from: Date(
                        timeIntervalSince1970: TimeInterval(reminder.datetime)
                    )
                ),
                month: Calendar.current.component(
                    .month, from: Date(
                        timeIntervalSince1970: TimeInterval(reminder.datetime)
                    )
                ),
                day: Calendar.current.component(
                    .day, from: Date(
                        timeIntervalSince1970: TimeInterval(reminder.datetime)
                    )
                ),
                hour: Calendar.current.component(
                    .hour, from: Date(
                        timeIntervalSince1970: TimeInterval(reminder.datetime)
                    )
                ),
                minute: Calendar.current.component(
                    .minute, from: Date(
                        timeIntervalSince1970: TimeInterval(reminder.datetime)
                    )
                ),
                second: Calendar.current.component(
                    .second, from: Date(
                        timeIntervalSince1970: TimeInterval(reminder.datetime)
                    )
                )
            ),
            repeats: false
        )
        let request = UNNotificationRequest(
            identifier: reminder.id,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling non-repeating notification: \(error)")
            } else {
                print("opora")
//                print("Non-repeating notification scheduled for \(trigger) with identifier: \(request.identifier)")
            }
        }
    }
}

struct ReminderAdd: View {
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .long
        return formatter
    }()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    @State var id:String?
    @State var datetime:Date
    @State var title:String
    @State var description:String
    @State var repeatable:Bool
    @State var hour:Int
    @State var minute:Int
    @State var second:Int
    
    @State var dom:Bool
    @State var seg:Bool
    @State var ter:Bool
    @State var qua:Bool
    @State var qui:Bool
    @State var sex:Bool
    @State var sab:Bool

    var body: some View {
        VStack {
            TextField("Título do Lembrete", text: $title)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            HStack {
                VStack {
                    Button("^") {
                        hour = (hour + 1)%24
                    }
                    Text(String(format: "%02d", hour)).font(.largeTitle)
                    Button("v") {
                        hour = (hour + (24 - 1))%24
                    }
                }
                Text(":").font(.largeTitle)
                VStack {
                    Button("^") {
                        minute = (minute + 1)%60
                    }
                    Text(String(format: "%02d", minute)).font(.largeTitle)
                    Button("v") {
                        minute = (minute + (60 - 1))%60
                    }
                }
                Text(":").font(.largeTitle)
                VStack {
                    Button("^") {
                        second = (second + 1)%60
                    }
                    Text(String(format: "%02d", second)).font(.largeTitle)
                    Button("v") {
                        second = (second + (60 - 1))%60
                    }
                }
            }
            TextEditor(text: $description)
                .frame(height: 100)
                .border(.black)
                .padding()
            Toggle("Repetir lembrete", isOn: $repeatable)
            if repeatable {
                HStack {
                    Button("D") {
                        dom.toggle()
                    }
                    .frame(width: 40, height: 40)
                    .background((dom ? .green : .gray))
                    .clipShape(Circle())
                    .tint(.black)
                    Button("S") {
                        seg.toggle()
                    }
                    .frame(width: 40, height: 40)
                    .background((seg ? .green : .gray))
                    .clipShape(Circle())
                    .tint(.black)
                    Button("T") {
                        ter.toggle()
                    }
                    .frame(width: 40, height: 40)
                    .background((ter ? .green : .gray))
                    .clipShape(Circle())
                    .tint(.black)
                    Button("Q") {
                        qua.toggle()
                    }
                    .frame(width: 40, height: 40)
                    .background((qua ? .green : .gray))
                    .clipShape(Circle())
                    .tint(.black)
                    Button("Q") {
                        qui.toggle()
                    }
                    .frame(width: 40, height: 40)
                    .background((qui ? .green : .gray))
                    .clipShape(Circle())
                    .tint(.black)
                    Button("S") {
                        sex.toggle()
                    }
                    .frame(width: 40, height: 40)
                    .background((sex ? .green : .gray))
                    .clipShape(Circle())
                    .tint(.black)
                    Button("S") {
                        sab.toggle()
                    }
                    .frame(width: 40, height: 40)
                    .background((sab ? .green : .gray))
                    .clipShape(Circle())
                    .tint(.black)
                }
            }
            
            Spacer()
            
//            Button("teste") {
//                UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
//                    print("Pending notification requests:")
//                    for request in requests {
//                        print("  - Identifier: \(request.identifier)")
//                        print("    Trigger: \(String(describing: request.trigger))")
//                        print("    Content: \(request.content.title) - \(request.content.subtitle)")
//                    }
//                }
//            }
            
            HStack {
                Spacer()
                NavigationLink(destination: ReminderView()) {
                    Button("Concluir") {
                        let reminder:Reminders = Reminders(
                            id: dateFormatter.string(from: Date()) + " "
                            + timeFormatter.string(from: Date()),
                            title: title,
                            description: description,
                            datetime: Int(Calendar.current.date(from: DateComponents(
                                year: Calendar.current.component(.year, from: Date()),
                                month: Calendar.current.component(.month, from: Date()),
                                day: Calendar.current.component(.day, from: Date()),
                                hour: hour,
                                minute: minute,
                                second: second
                            ))!.timeIntervalSince1970),
                            isRepeatable: repeatable,
                            repeatDays: [
                                dom, seg, ter, qua, qui, sex, sab
                            ]
                        )
                        
                        scheduleNotification(reminder:reminder)
                        // TODO: post
                        ViewModel().uploadReminder(reminder: reminder)
                        
                    }.font(.title).bold()
                }
                
                if id != nil {
                    Spacer()
                    Button("Deletar") {
                        UNUserNotificationCenter.current()
                            .removePendingNotificationRequests(
                                withIdentifiers: [id!]
                            )
                        // TODO: delete
                    }.font(.title).bold()
                        .foregroundColor(.red)
                }
                Spacer()
            }
        }.padding()
    }
}

struct ReminderView: View {
    @State var add:Bool = false
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    @StateObject var vm = ViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                NavBarView()
//                NavigationLink("Adicionar Nota", destination: NewReminderView())
//                    .font(.title)
                
                Spacer()
                
                Text("Últimos Alarmes")
                    .font(.title)
            
                /*List(vm.reminders) { reminder in
                    ScrollView {
                        VStack {
                            NavigationLink("\(reminder.title)", destination: ReminderDetailView(reminder: reminder))
                                .font(.title).multilineTextAlignment(.leading).padding(.leading, 20)
                            Text("\(reminder.description)").font(.title2).multilineTextAlignment(.trailing).padding(.leading, 20)
                        }.frame(height: 100)

                    }
                }*/
                List {
                    ForEach(vm.reminders) { alarme in
                        HStack(alignment: .center) {
                            NavigationLink(destination: ReminderAdd(
                                id: alarme.id,
                                datetime: Date(timeIntervalSince1970: TimeInterval(alarme.datetime)),
                                title: alarme.title,
                                description: alarme.description,
                                repeatable: alarme.isRepeatable,
                                hour: Int(Calendar.current.component(
                                    .hour, from: Date(timeIntervalSince1970: TimeInterval(alarme.datetime))
                                )),
                                minute: Int(Calendar.current.component(
                                    .minute, from: Date(timeIntervalSince1970: TimeInterval(alarme.datetime))
                                )),
                                second: Int(Calendar.current.component(
                                    .second, from: Date(timeIntervalSince1970: TimeInterval(alarme.datetime))
                                )),
                                dom: alarme.repeatDays[0],
                                seg: alarme.repeatDays[1],
                                ter: alarme.repeatDays[2],
                                qua: alarme.repeatDays[3],
                                qui: alarme.repeatDays[4],
                                sex: alarme.repeatDays[5],
                                sab: alarme.repeatDays[6]
                            )) {
                                VStack {
                                    Text(alarme.title)
                                        .font(.title)
                                        .padding(.leading, 10)
                                        .multilineTextAlignment(.leading)
                                    
                                    Text(timeFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(alarme.datetime))))
                                        .font(.title)
                                        .padding(.leading, 10)
                                        .multilineTextAlignment(.leading)
                                }
                            }.frame(height: 100)
                        }.padding([.trailing], 10)
                    }
                }
                .onAppear {
                    Task {
                        vm.fetchReminders()
                    }
                }
                
                NavigationLink(destination: ReminderAdd(
                    datetime: Date(),
                    title: "Lembrete "
                        + dateFormatter.string(from: Date()) + " "
                        + timeFormatter.string(from: Date()),
                    description: "",
                    repeatable: false,
                    hour: Int(Calendar.current.component(
                        .hour, from: Date()
                    )),
                    minute: Int(Calendar.current.component(
                        .minute, from: Date()
                    )),
                    second: 0,
                    dom: false,
                    seg: false,
                    ter: false,
                    qua: false,
                    qui: false,
                    sex: false,
                    sab: false
                )) {
                    Text("Adicionar lembrete")
                }
            }
        }
    }
}
#Preview {
    ReminderView()
}
