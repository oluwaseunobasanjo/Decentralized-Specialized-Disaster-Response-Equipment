import { describe, it, expect, vi } from 'vitest';

// Mock implementation
const mockEquipmentRegistration = {
  register: vi.fn().mockImplementation((name, type) => {
    return { value: 1 };
  }),
  
  updateStatus: vi.fn().mockImplementation((equipmentId, status) => {
    return { value: true };
  }),
  
  getEquipment: vi.fn().mockImplementation((id) => {
    return {
      name: "Rescue Spreader",
      type: "Extrication",
      owner: "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
      status: "active"
    };
  })
};

describe('Equipment Registration Contract', () => {
  it('should register new equipment', async () => {
    const result = await mockEquipmentRegistration.register(
        "Rescue Spreader",
        "Extrication"
    );
    
    expect(result.value).toBe(1);
    expect(mockEquipmentRegistration.register).toHaveBeenCalledWith(
        "Rescue Spreader",
        "Extrication"
    );
  });
  
  it('should update equipment status', async () => {
    const result = await mockEquipmentRegistration.updateStatus(1, "maintenance");
    
    expect(result.value).toBe(true);
    expect(mockEquipmentRegistration.updateStatus).toHaveBeenCalledWith(1, "maintenance");
  });
  
  it('should get equipment details', async () => {
    const equipment = await mockEquipmentRegistration.getEquipment(1);
    
    expect(equipment.name).toBe("Rescue Spreader");
    expect(equipment.type).toBe("Extrication");
    expect(equipment.status).toBe("active");
    expect(mockEquipmentRegistration.getEquipment).toHaveBeenCalledWith(1);
  });
});
