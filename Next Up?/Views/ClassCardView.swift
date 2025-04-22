import SwiftUI

struct ClassCardView: View {
    @StateObject var viewModel: ClassViewModel
    
    var body: some View {
        let classTypeColor = {
            switch viewModel.classTypeText {
            case "Лекція": return Color.blue
            case "Практична": return Color.orange
            case "Лабораторна": return Color.purple
            default: return .secondary
            }
        }()
        
        VStack(alignment: .leading) {
            HStack{
                Text(viewModel.numberText)
                    .font(.system(size: 15, weight: .bold))
                    .lineLimit(1)
                    .foregroundColor(.secondary)
                Spacer()
                Text(viewModel.classHoursText)
                    .font(.system(size: 15, weight: .regular))
                    .lineLimit(1)
                    .foregroundColor(.secondary)
            }
            .padding(-4)
            Rectangle()
                .fill(.secondary)
                .frame(height: 1)
                .padding(.horizontal, -20)
            Text(viewModel.name)
                .font(.system(size: 15, weight: .bold))
            HStack{
                Text(viewModel.teachersText)
                    .font(.system(size: 15, weight: .regular))
                    .lineLimit(1)
                    .foregroundColor(.secondary)
                Text(viewModel.locationsText)
                    .font(.system(size: 15, weight: .regular))
                    .lineLimit(1)
                    .foregroundColor(.secondary)
            }
            Text(viewModel.classTypeText)
                .font(.system(size: 15, weight: .regular))
                .lineLimit(1)
                .foregroundColor(classTypeColor)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.secondary.opacity(0.2), lineWidth: 1)
            RoundedRectangle(cornerRadius: 20)
                .stroke(.secondary.opacity(0.3), lineWidth: 1)
                .blur(radius: 5)
        }
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 3)
    }
}
